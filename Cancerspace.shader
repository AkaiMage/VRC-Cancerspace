Shader "RedMage/Cancerspace" {
	Properties {
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 4
		[Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Int) = 1
		_ColorMask ("Color Mask", Int) = 15
		
		_StencilRef ("Ref", Int) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Compare Function", Int) = 8
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilPassOp ("Pass Operation", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilFailOp ("Fail Operation", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilZFailOp ("ZFail Operation", Int) = 0
		_StencilReadMask ("Read Mask", Int) = 255
		_StencilWriteMask ("Write Mask", Int) = 255
		
		_Puffiness ("Puffiness", Float) = 0
		_ObjectPositionX ("Object Position X", Float) = 0
		_ObjectPositionY ("Object Position Y", Float) = 0
		_ObjectPositionZ ("Object Position Z", Float) = 0
		_ObjectPositionA ("Object Position A", Float) = 0
		_ObjectRotationX ("Object Rotation X", Float) = 0
		_ObjectRotationY ("Object Rotation Y", Float) = 0
		_ObjectRotationZ ("Object Rotation Z", Float) = 0
		_ObjectRotationA ("Object Rotation A", Float) = 0
		_ObjectScaleX ("Object Scale X", Float) = 1
		_ObjectScaleY ("Object Scale Y", Float) = 1
		_ObjectScaleZ ("Object Scale Z", Float) = 1
		_ObjectScaleA ("Object Scale A", Float) = 1
		
		_MaxFalloff ("Falloff Range", Float) = 30
		
		_BlurRadius ("Blur Radius", Range(0, 50)) = 0
		_BlurSampling ("Blur Sampling", Range(1, 5)) = 1
		[Toggle(_)] _AnimatedSampling ("Animated Sampling", Float) = 1
		
		_Zoom ("Zoom", Range(-10, 10)) = 1
		[PowerSlider(2.0)] _Pixelation ("Pixelation", Range(0, 1)) = 0
		
		[PowerSlider(2.0)] _XWobbleAmount ("X Amount", Range(0,1)) = 0
		[PowerSlider(2.0)] _YWobbleAmount ("Y Amount", Range(0,1)) = 0
		[PowerSlider(2.0)] _XWobbleTiling ("X Tiling", Range(0,3.141592653589793238)) = 0.1
		[PowerSlider(2.0)] _YWobbleTiling ("Y Tiling", Range(0,3.141592653589793238)) = 0.1
		[PowerSlider(2.0)] _XWobbleSpeed ("X Speed", Range(0, 100)) = 100
		[PowerSlider(2.0)] _YWobbleSpeed ("Y Speed", Range(0, 100)) = 100
		
		[Enum(Normal, 0, Melt, 1)] _DistortionType ("Distortion Type", Int) = 0
		[Enum(Screen, 0, Overlay, 1, Both, 2)] _DistortionTarget ("Target", Int) = 0
		_BumpMap ("Distortion Map (Normal)", 2D) = "bump" {}
		_MeltMap ("Melt Map", 2D) = "white" {}
		_MeltActivationScale ("Activation Time Scale", Range(0, 3)) = 1
		_MeltController ("Controller", Range(0, 3)) = 0
		_DistortionAmplitude ("Amplitude", Range(-1, 1)) = 0.1
		_BumpMapScrollSpeedX ("Scroll Speed X", Range(-2, 2)) = 0
		_BumpMapScrollSpeedY ("Scroll Speed Y", Range(-2, 2)) = 0
		
		[PowerSlider(2.0)]_XShake ("X Shake", Range(0, 1)) = 0
		[PowerSlider(2.0)]_YShake ("Y Shake", Range(0, 1)) = 0
		_XShakeSpeed ("X Shake Speed", Range(0, 300)) = 200
		_YShakeSpeed ("Y Shake Speed", Range(0, 300)) = 300
		_ShakeAmplitude ("Shake Amplitude", Range(0, 2)) = 1
		
		
		[Enum(Image, 0, Flipbook, 1, Cubemap, 2)] _OverlayImageType ("Overlay Type", Int) = 0
		[Enum(Clamp, 0, Repeat, 1, Screen, 2)] _OverlayBoundaryHandling ("Boundary Handling", Int) = 1
		[Toggle(_)] _PixelatedSampling ("Pixelate", Int) = 0
		_MainTex ("Image Overlay", 2D) = "white" {}
		_MainTexScrollSpeedX ("Scroll Speed X", Range(-2, 2)) = 0
		_MainTexScrollSpeedY ("Scroll Speed Y", Range(-2, 2)) = 0
		[NoScaleOffset] _OverlayCubemap ("Cubemap Overlay", Cube) = "white" {}
		[HDR] _OverlayColor ("Overlay Color", Color) = (1,1,1,1)
		_FlipbookTotalFrames ("Total Frames", Int) = 0
		_FlipbookFPS ("Frames per second", Float) = 1
		_FlipbookStartFrame ("Start Frame", Int) = 0
		_FlipbookColumns ("Columns", Int) = 20
		_FlipbookRows ("Rows", Int) = 20
		_OverlayCubemapRotationX ("Rotation X", Range(0, 360)) = 0
		_OverlayCubemapRotationY ("Rotation Y", Range(0, 360)) = 0
		_OverlayCubemapRotationZ ("Rotation Z", Range(0, 360)) = 0
		_OverlayCubemapSpeedX ("Rotation Speed X", Range(-360, 360)) = 0
		_OverlayCubemapSpeedY ("Rotation Speed Y", Range(-360, 360)) = 0
		_OverlayCubemapSpeedZ ("Rotation Speed Z", Range(-360, 360)) = 0
		_BlendAmount ("Opacity", Range(0,1)) = 0.5
		_BlendMode ("Blend Mode", Int) = 0
		
		
		_HueAdd ("Hue Add", Range(-1, 1)) = 0
		_SaturationAdd ("Saturation Add", Range(-1, 1)) = 0
		_ValueAdd ("Value Add", Range(-1, 1)) = 0
		_HueMultiply ("Hue Multiply", Range(-40, 40)) = 1
		_SaturationMultiply ("Saturation Multiply", Range(0, 1)) = 1
		_ValueMultiply ("Value Multiply", Range(0, 5)) = 1
		
		_InversionAmount ("Inversion Amount", Range(0,1)) = 0
		[HDR] _Color ("Screen Color", Color) = (1,1,1,1)
		
		[Toggle(_)] _Burn ("Color Burning", Int) = 0
		_BurnLow ("Color Burn Low", Range(-5, 5)) = 0
		_BurnHigh ("Color Burn High", Range(-5, 5)) = 1
		
		[Enum(Clamp, 0, Repeat, 1, Overlay, 2)] _ScreenBoundaryHandling ("Screen Boundary Handling", Int) = 0
		_ScreenXOffsetR ("Screen X Offset (Red)", Range(-1, 1)) = 0
		_ScreenXOffsetG ("Screen X Offset (Green)", Range(-1, 1)) = 0
		_ScreenXOffsetB ("Screen X Offset (Blue)", Range(-1, 1)) = 0
		_ScreenXOffsetA ("Screen X Offset (All)", Range(-1, 1)) = 0
		_ScreenYOffsetR ("Screen Y Offset (Red)", Range(-1, 1)) = 0
		_ScreenYOffsetG ("Screen Y Offset (Green)", Range(-1, 1)) = 0
		_ScreenYOffsetB ("Screen Y Offset (Blue)", Range(-1, 1)) = 0
		_ScreenYOffsetA ("Screen Y Offset (All)", Range(-1, 1)) = 0
		_ScreenXMultiplierR ("Screen X Multiplier (Red)", Range(-5, 5)) = 1
		_ScreenXMultiplierG ("Screen X Multiplier (Green)", Range(-5, 5)) = 1
		_ScreenXMultiplierB ("Screen X Multiplier (Blue)", Range(-5, 5)) = 1
		_ScreenXMultiplierA ("Screen X Multiplier (All)", Range(-5, 5)) = 1
		_ScreenYMultiplierR ("Screen Y Multiplier (Red)", Range(-5, 5)) = 1
		_ScreenYMultiplierG ("Screen Y Multiplier (Green)", Range(-5, 5)) = 1
		_ScreenYMultiplierB ("Screen Y Multiplier (Blue)", Range(-5, 5)) = 1
		_ScreenYMultiplierA ("Screen Y Multiplier (All)", Range(-5, 5)) = 1
		_ScreenRotationOriginX ("Screen Rotation Origin X (RGB)", Vector) = (0,0,0,.5)
		_ScreenRotationOriginY ("Screen Rotation Origin Y (RGB)", Vector) = (0,0,0,.5)
		_ScreenRotationAngle ("Screen Rotation Angle (RGB)", Vector) = (0,0,0,0)
		
		[Enum(Normal, 0, No Reflection, 1, Render Only In Mirror, 2)] _MirrorMode ("Mirror Reflectance", Int) = 0
	}
	SubShader {
		Tags { "Queue" = "Transparent+3" }
		
		Stencil {
			Ref [_StencilRef]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			Comp [_StencilComp]
			Pass [_StencilPassOp]
			Fail [_StencilFailOp]
			ZFail [_StencilZFailOp]
		}
		
		Cull [_CullMode]
		ZTest [_ZTest]
		ZWrite [_ZWrite]
		ColorMask [_ColorMask]
		
		GrabPass { "_Garb" }

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#define BLENDMODE_MULTIPLY 0
			#define BLENDMODE_SCREEN 1
			#define BLENDMODE_OVERLAY 2
			#define BLENDMODE_ADD 3
			#define BLENDMODE_SUBTRACT 4
			#define BLENDMODE_DIFFERENCE 5
			#define BLENDMODE_DIVIDE 6
			#define BLENDMODE_DARKEN 7
			#define BLENDMODE_LIGHTEN 8
			#define BLENDMODE_NORMAL 9
			#define BLENDMODE_COLORDODGE 10
			#define BLENDMODE_COLORBURN 11
			#define BLENDMODE_HARDLIGHT 12
			#define BLENDMODE_SOFTLIGHT 13
			#define BLENDMODE_EXCLUSION 14
			
			#define BOUNDARYMODE_CLAMP 0
			#define BOUNDARYMODE_REPEAT 1
			#define BOUNDARYMODE_OVERLAY 2
			#define BOUNDARYMODE_SCREEN 2
			
			#define OVERLAY_IMAGE 0
			#define OVERLAY_FLIPBOOK 1
			#define OVERLAY_CUBEMAP 2
			
			#define DISTORT_NORMAL 0
			#define DISTORT_MELT 1
			
			#define DISTORT_TARGET_SCREEN 0
			#define DISTORT_TARGET_OVERLAY 1
			#define DISTORT_TARGET_BOTH 2
			
			// apparently Unity doesn't animate vector fields properly, so time for some hacky workarounds
			#define _ScreenXOffset float4(_ScreenXOffsetR, _ScreenXOffsetG, _ScreenXOffsetB, _ScreenXOffsetA)
			#define _ScreenYOffset float4(_ScreenYOffsetR, _ScreenYOffsetG, _ScreenYOffsetB, _ScreenYOffsetA)
			#define _ScreenXMultiplier float4(_ScreenXMultiplierR, _ScreenXMultiplierG, _ScreenXMultiplierB, _ScreenXMultiplierA)
			#define _ScreenYMultiplier float4(_ScreenYMultiplierR, _ScreenYMultiplierG, _ScreenYMultiplierB, _ScreenYMultiplierA)
			#define _HSVAdd float3(_HueAdd, _SaturationAdd, _ValueAdd)
			#define _HSVMultiply float3(_HueMultiply, _SaturationMultiply, _ValueMultiply)
			#define _ObjectPosition (float3(_ObjectPositionX, _ObjectPositionY, _ObjectPositionZ) + _ObjectPositionA)
			#define _ObjectScale (float3(_ObjectScaleX, _ObjectScaleY, _ObjectScaleZ) * _ObjectScaleA)
			#define _MainTexScrollSpeed float2(_MainTexScrollSpeedX, _MainTexScrollSpeedY)
			#define _BumpMapScrollSpeed float2(_BumpMapScrollSpeedX, _BumpMapScrollSpeedY)
			
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
				float3 cubemapSampler : TEXCOORD3;
			};

			int _OverlayImageType;
			int _OverlayBoundaryHandling;
			
			sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			float4 _MainTex_ST;
			float _MainTexScrollSpeedX, _MainTexScrollSpeedY;
			
			int _PixelatedSampling;
			
			int _FlipbookRows, _FlipbookColumns;
			int _FlipbookStartFrame;
			int _FlipbookTotalFrames;
			float _FlipbookFPS;
			
			samplerCUBE _OverlayCubemap;
			float _OverlayCubemapRotationX, _OverlayCubemapRotationY, _OverlayCubemapRotationZ;
			float _OverlayCubemapSpeedX, _OverlayCubemapSpeedY, _OverlayCubemapSpeedZ;
			
			sampler2D _Garb;
			float4 _Garb_TexelSize;
			
			float4 _OverlayColor;
			float4 _Color;
			
			float _XShake, _YShake;
			float _XShakeSpeed, _YShakeSpeed;
			float _ShakeAmplitude;
			
			float _XWobbleAmount, _YWobbleAmount, _XWobbleTiling, _YWobbleTiling, _XWobbleSpeed, _YWobbleSpeed;
			
			int _BlendMode;
			float _BlendAmount;
			
			float _InversionAmount;
			
			float _Pixelation;
			
			float _HueAdd, _SaturationAdd, _ValueAdd;
			float _HueMultiply, _SaturationMultiply, _ValueMultiply;
			
			float _Zoom;
			
			int _Burn;
			float _BurnLow, _BurnHigh;
			
			float _MaxFalloff;
			
			float _Puffiness;
			
			float _ObjectPositionX, _ObjectPositionY, _ObjectPositionZ, _ObjectPositionA;
			float _ObjectRotationX, _ObjectRotationY, _ObjectRotationZ;
			float _ObjectScaleX, _ObjectScaleY, _ObjectScaleZ, _ObjectScaleA;
			
			int _MirrorMode;
			
			float _ScreenXOffsetR, _ScreenXOffsetG, _ScreenXOffsetB, _ScreenXOffsetA;
			float _ScreenYOffsetR, _ScreenYOffsetG, _ScreenYOffsetB, _ScreenYOffsetA;
			float _ScreenXMultiplierR, _ScreenXMultiplierG, _ScreenXMultiplierB, _ScreenXMultiplierA;
			float _ScreenYMultiplierR, _ScreenYMultiplierG, _ScreenYMultiplierB, _ScreenYMultiplierA;
			
			float4 _ScreenRotationOriginX, _ScreenRotationOriginY;
			
			float4 _ScreenRotationAngle;
			
			int _ScreenBoundaryHandling;
			
			// blurring method is based on https://www.shadertoy.com/view/XsVBDR
			
			int _BlurSampling;
			float _AnimatedSampling;
			float _BlurRadius;
			
			int _DistortionType, _DistortionTarget;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float _DistortionAmplitude;
			float _BumpMapScrollSpeedX, _BumpMapScrollSpeedY;
			sampler2D _MeltMap;
			float4 _MeltMap_ST;
			float _MeltController, _MeltActivationScale;
			
			float2 hash23(float3 p) {
				if (_AnimatedSampling) p.z += frac(_Time.z) * 4;
				p = frac(p * float3(400, 450, .1));
				p += dot(p, p.yzx + 20);
				return frac((p.xx + p.yz) * p.zy);
			}
			
			float3 hsv2rgb(float3 c) {
				return ((clamp(abs(frac(c.x+float3(0,.666,.333))*6-3)-1,0,1)-1)*c.y+1)*c.z;
			}
			
			float3 rgb2hsv(float3 c) {
				float4 K = float4(0, -.333, .666, -1);
				float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
				float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));

				float d = q.x - min(q.w, q.y);
				float e = 1e-10;
				return float3(abs(q.z + (q.w - q.y) / (6 * d + e)), d / (q.x + e), q.x);
			}
			
			float2x2 createRotationMatrix(float deg) {
				float s, c;
				sincos(deg * (UNITY_PI / 180), s, c);
				return float2x2(c, s, -s, c);
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
				return mul(createRotationMatrix(angle), uv - offset) + offset;
			}
			
			float2 computeScreenSpaceOverlayUV(float3 worldSpacePos) {
				float3 viewSpace = mul(UNITY_MATRIX_V, worldSpacePos - _WorldSpaceCameraPos);
				float2 adjusted = viewSpace.xy / viewSpace.z;
				return .5 * (1 - adjusted * float2(_ScreenParams.z / _ScreenParams.w, 1));
			}
			
			bool isInMirror() {
				return unity_CameraProjection[2][0] != 0 || unity_CameraProjection[2][1] != 0;
			}
			
			float2 pixelateSamples(float2 res, float2 invRes, float2 uv) {
				uv *= res;
				return (floor(uv) + smoothstep(0, fwidth(uv), frac(uv)) - .5) * invRes;
			}
			
			float3 colorDodge(float3 b, float3 s) {
				float3 res;
				UNITY_UNROLL for (int i = 0; i < 3; ++i) {
					if (b[i] == 0) res[i] = 0;
					else if (s[i] == 1) res[i] = 1;
					else res[i] = min(1, b[i] / (1 - s[i]));
				}
				return res;
			}
			
			float3 colorBurn(float3 b, float3 s) {
				float3 res;
				UNITY_UNROLL for (int i = 0; i < 3; ++i) {
					if (b[i] == 1) res[i] = 1;
					else if (s[i] == 0) res[i] = 0;
					else res[i] = 1 - min(1, (1 - b[i]) / s[i]);
				}
				return res;
			}
			
			float3 hardLight(float3 b, float3 s) {
				float3 res;
				UNITY_UNROLL for (int i = 0; i < 3; ++i) {
					if (s[i] <= .5) res[i] = 2 * s[i] * b[i];
					else res[i] = 1 - 2 * (1 - b[i]) * (1 - s[i]);
				}
				return res;
			}
			
			float3 softLight(float3 b, float3 s) {
				float3 res;
				UNITY_UNROLL for (int i = 0; i < 3; ++i) {
					if (s[i] <= .5) res[i] = (1 - (1 - 2 * s[i]) * (1 - b[i])) * b[i];
					else {
						float d;
						if (b[i] <= .25) d = ((16 * b[i] - 12) * b[i] + 4) * b[i];
						else d = sqrt(b[i]);
						res[i] = b[i] + (2 * s[i] - 1) * (d - b[i]);
					}
				}
				return res;
			}
			
			v2f vert (appdata v) {
				v2f o;
				
				v.vertex.yz = mul(createRotationMatrix(_ObjectRotationX), v.vertex.yz);
				v.vertex.xz = mul(createRotationMatrix(_ObjectRotationY), v.vertex.xz);
				v.vertex.xy = mul(createRotationMatrix(_ObjectRotationZ), v.vertex.xy);
				v.vertex.xyz *= _ObjectScale;
				v.vertex.xyz += _Puffiness * v.normal;
				
				v.vertex.xyz += _ObjectPosition;
				
				o.pos = UnityObjectToClipPos(v.vertex);
				o.posWorld = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.projPos = ComputeScreenPos(o.pos);
				o.posOrigin = ComputeScreenPos(UnityObjectToClipPos(float4(0,0,0,1)));
				o.posOrigin.xy /= o.posOrigin.w;
				o.cubemapSampler = o.posWorld - _WorldSpaceCameraPos;
				o.cubemapSampler.yz = mul(createRotationMatrix(_OverlayCubemapRotationX + _Time.y * _OverlayCubemapSpeedX), o.cubemapSampler.yz);
				o.cubemapSampler.xz = mul(createRotationMatrix(_OverlayCubemapRotationY + _Time.y * _OverlayCubemapSpeedY), o.cubemapSampler.xz);
				o.cubemapSampler.xy = mul(createRotationMatrix(_OverlayCubemapRotationZ + _Time.y * _OverlayCubemapSpeedZ), o.cubemapSampler.xy);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target {
				if (_MirrorMode == 1 && isInMirror() || _MirrorMode == 2 && !isInMirror()) discard;
			
				float3 originPoint = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz - _WorldSpaceCameraPos;
				if (dot(originPoint, originPoint) > _MaxFalloff * _MaxFalloff) discard;
				
				float VRFix = 1;
				#if defined(USING_STEREO_MATRICES)
				VRFix = .5;
				#endif
				
				float2 screenSpaceOverlayUV = computeScreenSpaceOverlayUV(i.posWorld);
				
				float2 distortion = 0;
				
				switch (_DistortionType) {
					case DISTORT_NORMAL:
						distortion = UnpackNormal(tex2D(_BumpMap, TRANSFORM_TEX((screenSpaceOverlayUV + _Time.yy * _BumpMapScrollSpeed - .5), _BumpMap) + .5)).xy * _DistortionAmplitude;
						break;
					case DISTORT_MELT:
						{
							float4 meltVal = tex2D(_MeltMap, TRANSFORM_TEX((screenSpaceOverlayUV - .5), _MeltMap) + .5);
							float2 motionVector = normalize(2 * meltVal.rg - 1);
							float activationTime = meltVal.b * _MeltActivationScale;
							float speed = meltVal.a * _DistortionAmplitude;
							if (_MeltController >= activationTime) {
								distortion = ((_MeltController - activationTime) * speed) * motionVector;
							}
						}
						break;
				}
				
				float4 color = 0;
				switch (_OverlayImageType) {
					case OVERLAY_IMAGE:
						{
							float2 uv = screenSpaceOverlayUV;
							if (_PixelatedSampling) uv = pixelateSamples(_MainTex_TexelSize.zw, _MainTex_TexelSize.xy, uv);
							
							if (_DistortionTarget == DISTORT_TARGET_OVERLAY || _DistortionTarget == DISTORT_TARGET_BOTH) uv += distortion;
							
							switch (_OverlayBoundaryHandling) {
								case BOUNDARYMODE_CLAMP:
									uv = saturate(uv);
									break;
								case BOUNDARYMODE_REPEAT:
									uv = frac(uv + _Time.yy * _MainTexScrollSpeed);
									break;
							}
							uv = TRANSFORM_TEX((uv - .5), _MainTex) + .5;
							if (_OverlayBoundaryHandling == BOUNDARYMODE_SCREEN && (saturate(uv.x) != uv.x || saturate(uv.y) != uv.y)) {
								color = 0;
							} else {
								color = tex2D(_MainTex, uv) * _OverlayColor;
							}
						}
						break;
					case OVERLAY_FLIPBOOK:
						{
							float currentFrame = floor(fmod(_FlipbookStartFrame + _Time.y * _FlipbookFPS, _FlipbookTotalFrames));
							float2 invCR = 1 / float2(_FlipbookColumns, _FlipbookRows);
							
							float2 uv = screenSpaceOverlayUV;
							if (_PixelatedSampling) uv = pixelateSamples(_MainTex_TexelSize.zw * invCR, _MainTex_TexelSize.xy * float2(_FlipbookColumns, _FlipbookRows), uv);
							
							if (_DistortionTarget == DISTORT_TARGET_OVERLAY || _DistortionTarget == DISTORT_TARGET_BOTH) uv += distortion;
							
							uv = TRANSFORM_TEX((uv - .5), _MainTex) + .5;
							switch (_OverlayBoundaryHandling) {
								case BOUNDARYMODE_CLAMP:
									uv = saturate(uv);
									break;
								case BOUNDARYMODE_REPEAT:
									uv = frac(uv + _Time.yy * _MainTexScrollSpeed);
									break;
							}
							
							float row = floor(currentFrame * invCR.x);
							float2 offset = float2(currentFrame - row * _FlipbookColumns, _FlipbookRows - row - 1);
							
							float2 newUVs = frac((uv + offset) * invCR);
							if (_OverlayBoundaryHandling == BOUNDARYMODE_SCREEN && (saturate(newUVs.x) != newUVs.x || saturate(newUVs.y) != newUVs.y)) {
								color = 0;
							} else {
								color = tex2Dlod(_MainTex, float4(newUVs, 0, 0)) * _OverlayColor;
							}
							
						}
						break;
					case OVERLAY_CUBEMAP:
						color = texCUBE(_OverlayCubemap, i.cubemapSampler) * _OverlayColor;
						break;
				}
				
				
				float2 displace = float2(_XShake, _YShake) * sin(_Time.yy * float2(_XShakeSpeed, _YShakeSpeed)) * _ShakeAmplitude;
				
				if (_DistortionTarget == DISTORT_TARGET_SCREEN || _DistortionTarget == DISTORT_TARGET_BOTH) displace += distortion;
				
				float2 grabUV = i.projPos.xy / i.projPos.w;
				grabUV -= i.posOrigin.xy;
				grabUV *= _Zoom;
				if (_Pixelation > 0) grabUV = floor(grabUV / _Pixelation) * _Pixelation;
				grabUV += i.posOrigin.xy;
				
				
				float2 wobbleTiling = i.pos.xy * float2(_XWobbleTiling, _YWobbleTiling);
				displace += float2(_XWobbleAmount, _YWobbleAmount) * sin(_Time.yy * float2(_XWobbleSpeed, _YWobbleSpeed) + wobbleTiling);
				
				
				
				displace.x *= VRFix;
				
				grabUV += displace;
				
				float4 grabCol = float4(0, 0, 0, 1);
				
				UNITY_LOOP for (int blurPass = 0; blurPass < _BlurSampling; ++blurPass) {
					float2 blurNoiseRand = hash23(float3(grabUV, (float) blurPass));
					
					blurNoiseRand.x *= UNITY_TWO_PI;
					
					float s, c;
					sincos(blurNoiseRand.x, s, c);
					
					float2 sampleUV = grabUV + (blurNoiseRand.y * _BlurRadius * float2(s, c)) / (_Garb_TexelSize.zw);
					
					float4 col;
					
					UNITY_UNROLL for (int j = 0; j < 3; ++j) {
						float2 multiplier = float2(_ScreenXMultiplier[j] * _ScreenXMultiplier.a, _ScreenYMultiplier[j] * _ScreenYMultiplier.a);
						float2 shift = float2(_ScreenXOffset[j] + _ScreenXOffset.a, _ScreenYOffset[j] + _ScreenYOffset.a);
						shift.x *= VRFix;
						float rotationAngle = _ScreenRotationAngle[j] + _ScreenRotationAngle.a;
						float2 rotationOrigin = float2(_ScreenRotationOriginX[j] + _ScreenRotationOriginX.a, _ScreenRotationOriginY[j] + _ScreenRotationOriginY.a);
						
						float2 uv = multiplier * (rotate(sampleUV + shift - rotationOrigin, rotationAngle) + rotationOrigin);
						
						switch (_ScreenBoundaryHandling) {
							case BOUNDARYMODE_CLAMP:
								/*
								 * technically not necessary since this should happen automatically,
								 * but I feel better about it by explicitly making sure it happens.
								 */
								uv = saturate(uv);
								break;
							case BOUNDARYMODE_REPEAT:
								uv = frac(uv);
								break;
						}
						
						if (_ScreenBoundaryHandling == BOUNDARYMODE_OVERLAY && (saturate(uv.x) != uv.x || saturate(uv.y) != uv.y)) {
							col[j] = color[j];
						} else {
							col[j] = tex2D(_Garb, uv)[j];
						}
					}
					
					grabCol = lerp(grabCol, col, 1 / (float) (blurPass + 1));
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
				
				switch (_BlendMode) {
					case BLENDMODE_MULTIPLY:
						blendedColor = finalScreenColor * color.rgb;
						break;
					case BLENDMODE_SCREEN:
						blendedColor = 1 - (1 - finalScreenColor) * (1 - color.rgb);
						break;
					case BLENDMODE_OVERLAY:
						blendedColor = hardLight(color.rgb, finalScreenColor);
						break;
					case BLENDMODE_ADD:
						blendedColor = saturate(finalScreenColor + color.rgb);
						break;
					case BLENDMODE_SUBTRACT:
						blendedColor = saturate(finalScreenColor - color.rgb);
						break;
					case BLENDMODE_DIFFERENCE:
						blendedColor = abs(finalScreenColor - color.rgb);
						break;
					case BLENDMODE_DIVIDE:
						blendedColor = saturate(finalScreenColor / color.rgb);
						break;
					case BLENDMODE_DARKEN:
						blendedColor = min(finalScreenColor, color.rgb);
						break;
					case BLENDMODE_LIGHTEN:
						blendedColor = max(finalScreenColor, color.rgb);
						break;
					case BLENDMODE_NORMAL:
						blendedColor = color.rgb;
						break;
					case BLENDMODE_COLORDODGE:
						blendedColor = colorDodge(finalScreenColor, color.rgb);
						break;
					case BLENDMODE_COLORBURN:
						blendedColor = colorBurn(finalScreenColor, color.rgb);
						break;
					case BLENDMODE_HARDLIGHT:
						blendedColor = hardLight(finalScreenColor, color.rgb);
						break;
					case BLENDMODE_SOFTLIGHT:
						blendedColor = softLight(finalScreenColor, color.rgb);
						break;
					case BLENDMODE_EXCLUSION:
						blendedColor = finalScreenColor + color.rgb - 2 * finalScreenColor * color.rgb;
						break;
				}
				
				finalScreenColor = lerp(finalScreenColor, blendedColor, blendAmount);
				
				return float4(finalScreenColor, 1) * _Color;
			}
			ENDCG
		}
	}
	CustomEditor "CancerspaceInspector"
}
