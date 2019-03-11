Shader "RedMage/Cancerspace" {
	Properties {
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 4
		
		[Header(Target Object Settings)]
		_Puffiness ("Puffiness", Float) = 0
		
		[Header(Falloff Settings)]
		_MaxFalloff ("Falloff Range", Float) = 30
		
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
		
		[Header(RGB Splitting)]
		_RedXShift ("Red X Shift", Float) = 0
		_RedYShift ("Red Y Shift", Float) = 0
		_GreenXShift ("Green X Shift", Float) = 0
		_GreenYShift ("Green Y Shift", Float) = 0
		_BlueXShift ("Blue X Shift", Float) = 0
		_BlueYShift ("Blue Y Shift", Float) = 0
		
		[Header(Overlay)]
		_MainTex ("Image Overlay", 2D) = "white" {}
		_OverlayColor ("Overlay Color", Color) = (1,1,1,1)
		_BlendAmount ("Blend Amount", Range(0,1)) = 0.5
		[Toggle(_)] _Multiply ("Multiply", Int) = 0
		
		[Header(Screen Color Adjustments)]
		_DesaturationAmount ("Saturation Multiplier", Range(0,1)) = 1
		_InversionAmount ("Inversion Amount", Range(0,1)) = 0
		_Color ("Screen Color", Color) = (1,1,1,1)
		
		[Header(Color Burning)]
		[Toggle(_)] _Burn ("Enabled", Int) = 0
		_BurnLow ("Color Burn Low", Float) = 0
		_BurnHigh ("Color Burn High", Float) = 1
		
		[Header(Screen Transformation)]
		_ScreenXMultiplier ("Screen X Multiplier (RGB)", Vector) = (1,1,1,1)
		_ScreenYMultiplier ("Screen Y Multiplier (RGB)", Vector) = (1,1,1,1)
		_ScreenRotationOriginX ("Screen Rotation Origin X (RGB)", Vector) = (.5,.5,.5,0)
		_ScreenRotationOriginY ("Screen Rotation Origin Y (RGB)", Vector) = (.5,.5,.5,0)
		_RotationAngle ("Screen Rotation Angle (RGB)", Vector) = (0,0,0,0)
		
		[Header(Misc)]
		[Enum(Normal, 0, No Reflection, 1, Render Only In Mirror, 2)] _MirrorMode("Mirror Reflectance", Int) = 0
	}
	SubShader {
		Tags { "Queue" = "Transparent+3" }
		
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
				float3 normal : NORMAL;
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
			
			int _Multiply;
			float _BlendAmount;
			
			float _InversionAmount;
			
			float _Pixelation;
			
			float _DesaturationAmount;
			
			float _Zoom;
			
			int _Burn;
			float _BurnLow, _BurnHigh;
			
			float _MaxFalloff;
			
			float _RedXShift, _RedYShift;
			float _GreenXShift, _GreenYShift;
			float _BlueXShift, _BlueYShift;
			
			float _Puffiness;
			
			int _MirrorMode;
			
			float4 _ScreenXMultiplier;
			float4 _ScreenYMultiplier;
			
			float4 _ScreenRotationOriginX;
			float4 _ScreenRotationOriginY;
			
			float4 _RotationAngle;
			
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
			
			float2 rotate(float2 uv, float angle) {
				float s, c;
				sincos(angle, s, c);
				return mul(float2x2(c, s, -s, c), uv);
			}
			
			bool isInMirror() {
				return unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f;
			}
			
			v2f vert (appdata v) {
				v2f o;
				v.vertex.xyz += _Puffiness * v.normal;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.projPos = ComputeScreenPos(o.pos);
				o.posOrigin = ComputeScreenPos(UnityObjectToClipPos(float4(0,0,0,1)));
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target {
				if (_MirrorMode == 1 && isInMirror() || _MirrorMode == 2 && !isInMirror()) discard;
			
				float3 originPoint = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz - _WorldSpaceCameraPos;
				
				if (dot(originPoint, originPoint) > _MaxFalloff * _MaxFalloff) discard;
				
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
				
				grabUV += displace;
				
				float red = tex2D(_Garb, frac(float2(_ScreenXMultiplier.r * _ScreenXMultiplier.a, _ScreenYMultiplier.r * _ScreenYMultiplier.a) * (rotate(grabUV + float2(_RedXShift, _RedYShift) / _Garb_TexelSize.zw - float2(_ScreenRotationOriginX.r + _ScreenRotationOriginX.a, _ScreenRotationOriginY.r + _ScreenRotationOriginY.a), _RotationAngle.r + _RotationAngle.a) + float2(_ScreenRotationOriginX.r + _ScreenRotationOriginX.a, _ScreenRotationOriginY.r + _ScreenRotationOriginY.a)))).r;
				float green = tex2D(_Garb, frac(float2(_ScreenXMultiplier.g * _ScreenXMultiplier.a, _ScreenYMultiplier.g * _ScreenYMultiplier.a) * (rotate(grabUV + float2(_GreenXShift, _GreenYShift) / _Garb_TexelSize.zw - float2(_ScreenRotationOriginX.g + _ScreenRotationOriginX.a, _ScreenRotationOriginY.g + _ScreenRotationOriginY.a), _RotationAngle.g + _RotationAngle.a) + float2(_ScreenRotationOriginX.g + _ScreenRotationOriginX.a, _ScreenRotationOriginY.g + _ScreenRotationOriginY.a)))).g;
				float blue = tex2D(_Garb, frac(float2(_ScreenXMultiplier.b * _ScreenXMultiplier.a, _ScreenYMultiplier.b * _ScreenYMultiplier.a) * (rotate(grabUV + float2(_BlueXShift, _BlueYShift) / _Garb_TexelSize.zw - float2(_ScreenRotationOriginX.b + _ScreenRotationOriginX.a, _ScreenRotationOriginY.b + _ScreenRotationOriginY.a), _RotationAngle.b + _RotationAngle.a) + float2(_ScreenRotationOriginX.b + _ScreenRotationOriginX.a, _ScreenRotationOriginY.b + _ScreenRotationOriginY.a)))).b;
				float4 grabCol = float4(red, green, blue, 1);
				
				grabCol.rgb = hsv2rgb(saturate(rgb2hsv(grabCol.rgb) * float3(1, _DesaturationAmount, 1)));
				if (_Burn) grabCol.rgb = smoothstep(_BurnLow, _BurnHigh, grabCol.rgb);
				
				float4 inverted = lerp(grabCol, float4(1 - grabCol.rgb, grabCol.a), _InversionAmount);
				
				float4 blended = float4(1,1,1,1);
				
				if (_Multiply) {
					blended = lerp(inverted, inverted * color * _Color, _BlendAmount);
				} else {
					blended = lerp(inverted, color * _Color, _BlendAmount);
				}
				
				
				return blended * _Color;
			}
			ENDCG
		}
	}
}
