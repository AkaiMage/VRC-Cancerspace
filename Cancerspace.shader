Shader "RedMage/Cancerspace" {
	Properties {
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 4
		
		[Header(Zoom Stuff)]
		_Zoom ("Zoom", Float) = 1
		[PowerSlider(5.0)] _Pixelation ("Pixelation", Range(0, 1)) = 0
		
		[Header(Wobbling)]
		_XWobbleAmount ("X Wobble Amount", Float) = 0
		_YWobbleAmount ("Y Wobble Amount", Float) = 0
		_XWobbleTiling ("X Wobble Tiling", Float) = 0.1
		_YWobbleTiling ("Y Wobble Tiling", Float) = 0.1
		_XWobbleSpeed ("X Wobble Speed", Float) = 300
		_YWobbleSpeed ("Y Wobble Speed", Float) = 300
		
		[Header(Screen Shake)]
		_XShake ("X Shake", Float) = 0
		_YShake ("Y Shake", Float) = 0
		_XShakeSpeed ("X Shake Speed", Float) = 100
		_YShakeSpeed ("Y Shake Speed", Float) = 100
		
		[Header(Overlay)]
		_MainTex ("Image Overlay", 2D) = "white" {}
		_OverlayColor ("Overlay Color", Color) = (1,1,1,1)
		_BlendAmount ("Blend Amount", Range(0,1)) = 0.5
		
		[Header(Screen Color Adjustments)]
		_DesaturationAmount ("Saturation Multiplier", Range(0,1)) = 1
		_InversionAmount ("Inversion Amount", Range(0,1)) = 0
		_Color ("Screen Color", Color) = (1,1,1,1)
		
		[Header(Color Burning)]
		[Toggle] _Burn ("Enabled", Int) = 0
		_BurnLow ("Color Burn Low", Float) = 0
		_BurnHigh ("Color Burn High", Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent+2" }
		LOD 100
		
		Cull [_CullMode]
		ZTest [_ZTest]
		
		GrabPass { "_Garb" }

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float3 posWorld : TEXCOORD0;
				float4 projPos : TEXCOORD1;
				float4 posOrigin : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			sampler2D _Garb;
			float4 _Garb_TexelSize;
			
			float4 _OverlayColor;
			float4 _Color;
			
			float _XShake;
			float _YShake;
			float _XShakeSpeed;
			float _YShakeSpeed;
			
			float _XWobbleAmount, _YWobbleAmount, _XWobbleTiling, _YWobbleTiling, _XWobbleSpeed, _YWobbleSpeed;
			
			float _BlendAmount;
			
			float _InversionAmount;
			
			float _Pixelation;
			
			float _DesaturationAmount;
			
			float _Zoom;
			
			int _Burn;
			float _BurnLow, _BurnHigh;
			
			float3 hsv2rgb(float3 c) {
				return ((clamp(abs(frac(c.x+float3(0,.666,.333))*6-3)-1,0,1)-1)*c.y+1)*c.z;
			}
			
			float3 rgb2hsv(float3 c) {
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
				float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));

				float d = q.x - min(q.w, q.y);
				float e = 1.0e-10;
				return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}
			
			v2f vert (appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.projPos = ComputeScreenPos(o.pos);
				o.posOrigin = ComputeScreenPos(UnityObjectToClipPos(float4(0,0,0,1)));
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target {
				float3 viewSpace = mul(UNITY_MATRIX_V, i.posWorld.xyz - _WorldSpaceCameraPos);
				float2 adjusted = viewSpace.xy / viewSpace.z;
				float2 uv = 1.0 - adjusted * float2(_ScreenParams.z / _ScreenParams.w, 1);
				float4 color = tex2D(_MainTex, TRANSFORM_TEX(uv, _MainTex)) * _OverlayColor;
				
				float2 displace = float2(_XShake, _YShake) * _Garb_TexelSize.xy * sin(_Time.yy * float2(_XShakeSpeed, _YShakeSpeed));
				
				float2 grabUV = i.projPos.xy / i.projPos.w;
				
				grabUV -= i.posOrigin.xy / i.posOrigin.w;
				grabUV *= _Zoom;
				grabUV += i.posOrigin.xy / i.posOrigin.w;
				
				displace += float2(_XWobbleAmount, _YWobbleAmount) * sin(_Time.yy * float2(_XWobbleSpeed, _YWobbleSpeed) + (i.pos.xy * float2(_XWobbleTiling, _YWobbleTiling)));
				
				if (_Pixelation > 0) grabUV = floor(grabUV / _Pixelation) * _Pixelation;
				float4 grabCol = tex2D(_Garb, grabUV + displace);
				
				grabCol.rgb = hsv2rgb(saturate(rgb2hsv(grabCol.rgb) * float3(1, _DesaturationAmount, 1)));
				if (_Burn) grabCol.rgb = smoothstep(_BurnLow, _BurnHigh, grabCol.rgb);
				
				float4 inverted = lerp(grabCol, float4(1 - grabCol.rgb, grabCol.a), _InversionAmount);
				float4 blended = lerp(inverted, color * _Color, _BlendAmount);
				
				return blended * _Color;
			}
			ENDCG
		}
	}
}
