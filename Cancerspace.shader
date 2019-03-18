Shader "RedMage/Cancerspace" {
	Properties {
		_InspectorCategoryExpansionFlags ("DO NOT TOUCH", Int) = 0
		
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 4
		
		_Puffiness ("Puffiness", Float) = 0
		
		_MaxFalloff ("Falloff Range", Float) = 30
		
		_Zoom ("Zoom", Float) = 1
		[PowerSlider(5.0)] _Pixelation ("Pixelation", Range(0, 1)) = 0
		
		[PowerSlider(2.0)]_XWobbleAmount ("X Wobble Amount", Range(0,1)) = 0
		[PowerSlider(2.0)]_YWobbleAmount ("Y Wobble Amount", Range(0,1)) = 0
		[PowerSlider(2.0)]_XWobbleTiling ("X Wobble Tiling", Range(0,3.141592653589793238)) = 0.1
		[PowerSlider(2.0)]_YWobbleTiling ("Y Wobble Tiling", Range(0,3.141592653589793238)) = 0.1
		_XWobbleSpeed ("X Wobble Speed", Float) = 300
		_YWobbleSpeed ("Y Wobble Speed", Float) = 300
		
		_XShake ("X Shake", Float) = 0
		_YShake ("Y Shake", Float) = 0
		_XShakeSpeed ("X Shake Speed", Float) = 100
		_YShakeSpeed ("Y Shake Speed", Float) = 100
		
		_MainTex ("Image Overlay", 2D) = "white" {}
		[HDR] _OverlayColor ("Overlay Color", Color) = (1,1,1,1)
		_BlendAmount ("Blend Amount", Range(0,1)) = 0.5
		_BlendMode ("Blend Mode", Int) = 0
		
		_HSVAdd ("HSV Add", Vector) = (0,0,0,0)
		_HSVMultiply ("HSV Multiply", Vector) = (1,1,1,1)
		_InversionAmount ("Inversion Amount", Range(0,1)) = 0
		[HDR] _Color ("Screen Color", Color) = (1,1,1,1)
		
		[Toggle(_)] _Burn ("Color Burning", Int) = 0
		_BurnLow ("Color Burn Low", Float) = 0
		_BurnHigh ("Color Burn High", Float) = 1
		
		[Enum(Clamp, 0, Repeat, 1)] _ScreenBoundaryHandling ("Screen Boundary Handling", Float) = 0
		_ScreenXOffset ("Screen X Offset (RGB)", Vector) = (0,0,0,0)
		_ScreenYOffset ("Screen Y Offset (RGB)", Vector) = (0,0,0,0)
		_ScreenXMultiplier ("Screen X Multiplier (RGB)", Vector) = (1,1,1,1)
		_ScreenYMultiplier ("Screen Y Multiplier (RGB)", Vector) = (1,1,1,1)
		_ScreenRotationOriginX ("Screen Rotation Origin X (RGB)", Vector) = (0,0,0,.5)
		_ScreenRotationOriginY ("Screen Rotation Origin Y (RGB)", Vector) = (0,0,0,.5)
		_RotationAngle ("Screen Rotation Angle (RGB)", Vector) = (0,0,0,0)
		
		[Enum(Normal, 0, No Reflection, 1, Render Only In Mirror, 2)] _MirrorMode ("Mirror Reflectance", Int) = 0
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
			
			int _BlendMode;
			float _BlendAmount;
			
			float _InversionAmount;
			
			float _Pixelation;
			
			float3 _HSVAdd;
			float3 _HSVMultiply;
			
			float _Zoom;
			
			int _Burn;
			float _BurnLow, _BurnHigh;
			
			float _MaxFalloff;
			
			float _Puffiness;
			
			int _MirrorMode;
			
			float4 _ScreenXOffset;
			float4 _ScreenYOffset;
			float4 _ScreenXMultiplier;
			float4 _ScreenYMultiplier;
			
			float4 _ScreenRotationOriginX;
			float4 _ScreenRotationOriginY;
			
			float4 _RotationAngle;
			
			float _ScreenBoundaryHandling;
			
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
				// FIXME: rotations aren't correctly displayed for some angles
				// just going to restrict to only angles that work for now.
				angle = round(angle / 180) * 180;
			
				//#if defined(USING_STEREO_MATRICES)
				//float2 offset = unity_StereoEyeIndex * float2(.5, 0);
				//#else
				float2 offset = float2(0, 0);
				//#endif
				float s, c;
				sincos(angle * UNITY_PI / 180, s, c);
				return mul(float2x2(c, s, -s, c), uv - offset) + offset;
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
				
				float2 wobbleTiling = i.pos.xy * float2(_XWobbleTiling, _YWobbleTiling);
				
				// account for a discrepancy between VR and desktop.
				#if defined(USING_STEREO_MATRICES)
				wobbleTiling *= float2(.5, 1);
				#endif
				
				displace += float2(_XWobbleAmount, _YWobbleAmount) * sin(_Time.yy * float2(_XWobbleSpeed, _YWobbleSpeed) + wobbleTiling);
				
				if (_Pixelation > 0) grabUV = floor(grabUV / _Pixelation) * _Pixelation;
				
				grabUV += displace;
				
				float4 grabCol = float4(0, 0, 0, 1);
				
				UNITY_UNROLL for (int j = 0; j < 3; ++j) {
					float2 multiplier = float2(_ScreenXMultiplier[j] * _ScreenXMultiplier.a, _ScreenYMultiplier[j] * _ScreenYMultiplier.a);
					float2 shift = float2(_ScreenXOffset[j] + _ScreenXOffset.a, _ScreenYOffset[j] + _ScreenYOffset.a);
					float rotationAngle = _RotationAngle[j] + _RotationAngle.a;
					float2 rotationOrigin = float2(_ScreenRotationOriginX[j] + _ScreenRotationOriginX.a, _ScreenRotationOriginY[j] + _ScreenRotationOriginY.a);
					
					float2 uv = multiplier * (rotate(grabUV + shift / _Garb_TexelSize.zw - rotationOrigin, rotationAngle) + rotationOrigin);
					if (_ScreenBoundaryHandling == 1) {
						uv = frac(uv);
					}
					grabCol[j] = tex2D(_Garb, uv)[j];
				}
				
				float3 hsv = rgb2hsv(grabCol.rgb) * _HSVMultiply + _HSVAdd;
				hsv.r = frac(hsv.r);
				hsv.gb = saturate(hsv.gb);
				grabCol.rgb = hsv2rgb(hsv);
				
				// lol one-liner for exposure and shit, GOML
				if (_Burn) grabCol.rgb = smoothstep(_BurnLow, _BurnHigh, grabCol.rgb);
				
				float3 finalScreenColor = lerp(grabCol, float4(1 - grabCol.rgb, grabCol.a), _InversionAmount);
				
				float blendAmount = _BlendAmount * color.a;
				float3 blendedColor = 0;
				
				if (_BlendMode == 0) blendedColor = finalScreenColor * color.rgb;
				else if (_BlendMode == 1) blendedColor = 1 - (1 - finalScreenColor) * (1 - color.rgb);
				else if (_BlendMode == 2) {
					UNITY_UNROLL for (int j = 0; j < 3; ++j) {
						if (finalScreenColor[j] < .5) blendedColor[j] = 2 * finalScreenColor[j] * color[j];
						else blendedColor[j] = 1 - 2 * (1 - finalScreenColor[j]) * (1 - color[j]);
					}
				} else if (_BlendMode == 3) blendedColor = saturate(finalScreenColor + color.rgb);
				else if (_BlendMode == 4) blendedColor = saturate(finalScreenColor - color.rgb);
				else if (_BlendMode == 5) blendedColor = abs(finalScreenColor - color.rgb);
				else if (_BlendMode == 6) blendedColor = saturate(finalScreenColor / color.rgb);
				else if (_BlendMode == 7) blendedColor = min(finalScreenColor, color.rgb);
				else if (_BlendMode == 8) blendedColor = max(finalScreenColor, color.rgb);
				
				finalScreenColor = lerp(finalScreenColor, blendedColor, blendAmount);
				
				return float4(finalScreenColor, 1) * _Color;
			}
			ENDCG
		}
	}
	CustomEditor "CancerspaceInspector"
}
