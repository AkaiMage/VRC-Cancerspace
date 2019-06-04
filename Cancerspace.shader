Shader "RedMage/Cancerspace" {
	Properties {
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 8
		[Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Int) = 1
		_ColorMask ("Color Mask", Int) = 15
		
		_StencilRef ("Ref", Int) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Compare Function", Int) = 8
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilPassOp ("Pass Operation", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilFailOp ("Fail Operation", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilZFailOp ("ZFail Operation", Int) = 0
		_StencilReadMask ("Read Mask", Int) = 255
		_StencilWriteMask ("Write Mask", Int) = 255
		
		[Enum(Flat, 0, Sphere, 1)] _ProjectionType ("Projection Type", Int) = 0
		
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
		
		_MinFalloff ("Min Falloff", Float) = 30
		_MaxFalloff ("Max Falloff", Float) = 60
		[Enum(Sharp, 0, Linear, 1, Smooth, 2)] _FalloffCurve ("Curve", Int) = 0
		
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
		_DistortionMapRotation ("Map Rotation", Range(0, 360)) = 0
		_MeltActivationScale ("Activation Time Scale", Range(0, 3)) = 1
		_MeltController ("Controller", Range(0, 3)) = 0
		_DistortionAmplitude ("Amplitude", Range(-1, 1)) = 0.1
		_DistortionRotation ("Direction Rotation", Range(0, 360)) = 0
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
		_MainTexRotation ("Rotation", Range(0, 360)) = 0
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
		
		[Toggle(_)] _Burn ("Color Burning (No Bloom)", Int) = 0
		_BurnLow ("Color Burn Low", Range(-5, 5)) = 0
		_BurnHigh ("Color Burn High", Range(-5, 5)) = 1
		
		[Enum(Clamp, 0, Repeat, 1, Overlay, 2)] _ScreenBoundaryHandling ("Screen Boundary Handling", Int) = 0
		[Toggle(_)] _ScreenReprojection ("Screen Reprojection", Int) = 0
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
		_ScreenRotationOriginXR ("Screen Rotation Origin X (Red)", Range(-1, 1)) = 0
		_ScreenRotationOriginXG ("Screen Rotation Origin X (Green)", Range(-1, 1)) = 0
		_ScreenRotationOriginXB ("Screen Rotation Origin X (Blue)", Range(-1, 1)) = 0
		_ScreenRotationOriginXA ("Screen Rotation Origin X (All)", Range(-1, 1)) = 0
		_ScreenRotationOriginYR ("Screen Rotation Origin Y (Red)", Range(-1, 1)) = 0
		_ScreenRotationOriginYG ("Screen Rotation Origin Y (Green)", Range(-1, 1)) = 0
		_ScreenRotationOriginYB ("Screen Rotation Origin Y (Blue)", Range(-1, 1)) = 0
		_ScreenRotationOriginYA ("Screen Rotation Origin Y (All)", Range(-1, 1)) = 0
		_ScreenRotationAngleR ("Screen Rotation Angle (Red)", Range(-360, 360)) = 0
		_ScreenRotationAngleG ("Screen Rotation Angle (Green)", Range(-360, 360)) = 0
		_ScreenRotationAngleB ("Screen Rotation Angle (Blue)", Range(-360, 360)) = 0
		_ScreenRotationAngleA ("Screen Rotation Angle (All)", Range(-360, 360)) = 0
		
		_DistortionMask ("Distortion Mask", 2D) = "white" {}
		_DistortionMaskOpacity ("Opacity", Range(0, 1)) = 1
		_OverlayMask ("Overlay Mask", 2D) = "white" {}
		_OverlayMaskOpacity ("Opacity", Range(0, 1)) = 1
		_OverallEffectMask ("Entire Effect Mask", 2D) = "white" {}
		_OverallEffectMaskOpacity ("Opacity", Range(0, 1)) = 1
		_OverallEffectMaskBlendMode ("Blend Mode", Int) = 9
		
		[Enum(Normal, 0, No Reflection, 1, Render Only In Mirror, 2)] _MirrorMode ("Mirror Reflectance", Int) = 0
		[Enum(Both, 0, Left, 1, Right, 2)] _EyeSelector ("Eye Discrimination", Int) = 0
		[Enum(Both, 0, Desktop, 1, VR, 2)] _PlatformSelector ("Platform Discrimination", Int) = 0
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
			
			#define PROJECTION_FLAT 0
			#define PROJECTION_SPHERE 1
			
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
			
			#define FALLOFF_CURVE_SHARP 0
			#define FALLOFF_CURVE_LINEAR 1
			#define FALLOFF_CURVE_SMOOTH 2
			
			#define MIRROR_NORMAL 0
			#define MIRROR_DISABLE 1
			#define MIRROR_ONLY 2
			
			#define EYE_BOTH 0
			#define EYE_LEFT 1
			#define EYE_RIGHT 2
			
			#define PLATFORM_ALL 0
			#define PLATFORM_DESKTOP 1
			#define PLATFORM_VR 2
			
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
			#define _ScreenRotationOriginX (float3(_ScreenRotationOriginXR, _ScreenRotationOriginXG, _ScreenRotationOriginXB) + _ScreenRotationOriginXA)
			#define _ScreenRotationOriginY (float3(_ScreenRotationOriginYR, _ScreenRotationOriginYG, _ScreenRotationOriginYB) + _ScreenRotationOriginYA)
			#define _ScreenRotationAngle (float3(_ScreenRotationAngleR, _ScreenRotationAngleG, _ScreenRotationAngleB) + _ScreenRotationAngleA)
			
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"

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
			
			int _ProjectionType;
			
			float _MinFalloff;
			float _MaxFalloff;
			int _FalloffCurve;

			int _OverlayImageType;
			int _OverlayBoundaryHandling;
			
			sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			float4 _MainTex_ST;
			float _MainTexScrollSpeedX, _MainTexScrollSpeedY;
			float _MainTexRotation;
			
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
			
			float _Puffiness;
			
			float _ObjectPositionX, _ObjectPositionY, _ObjectPositionZ, _ObjectPositionA;
			float _ObjectRotationX, _ObjectRotationY, _ObjectRotationZ;
			float _ObjectScaleX, _ObjectScaleY, _ObjectScaleZ, _ObjectScaleA;
			
			int _MirrorMode;
			
			int _ScreenReprojection;
			float _ScreenXOffsetR, _ScreenXOffsetG, _ScreenXOffsetB, _ScreenXOffsetA;
			float _ScreenYOffsetR, _ScreenYOffsetG, _ScreenYOffsetB, _ScreenYOffsetA;
			float _ScreenXMultiplierR, _ScreenXMultiplierG, _ScreenXMultiplierB, _ScreenXMultiplierA;
			float _ScreenYMultiplierR, _ScreenYMultiplierG, _ScreenYMultiplierB, _ScreenYMultiplierA;
			
			float _ScreenRotationOriginXR, _ScreenRotationOriginXG, _ScreenRotationOriginXB, _ScreenRotationOriginXA;
			float _ScreenRotationOriginYR, _ScreenRotationOriginYG, _ScreenRotationOriginYB, _ScreenRotationOriginYA;
			
			float _ScreenRotationAngleR, _ScreenRotationAngleG, _ScreenRotationAngleB, _ScreenRotationAngleA;
			
			int _ScreenBoundaryHandling;
			
			// blurring method is based on https://www.shadertoy.com/view/XsVBDR
			
			int _BlurSampling;
			float _AnimatedSampling;
			float _BlurRadius;
			
			int _DistortionType, _DistortionTarget;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float _DistortionMapRotation;
			float _DistortionAmplitude;
			float _DistortionRotation;
			float _BumpMapScrollSpeedX, _BumpMapScrollSpeedY;
			sampler2D _MeltMap;
			float4 _MeltMap_ST;
			float _MeltController, _MeltActivationScale;
			
			sampler2D _DistortionMask;
			float4 _DistortionMask_ST;
			float _DistortionMaskOpacity;
			sampler2D _OverlayMask;
			float4 _OverlayMask_ST;
			float _OverlayMaskOpacity;
			sampler2D _OverallEffectMask;
			float4 _OverallEffectMask_ST;
			float _OverallEffectMaskOpacity;
			int _OverallEffectMaskBlendMode;
			
			int _EyeSelector;
			int _PlatformSelector;
			
			float2 hash23(float3 p) {
				if (_AnimatedSampling) p.z += frac(_Time.z) * 4;
				p = frac(p * float3(400, 450, .1));
				p += dot(p, p.yzx + 20);
				return frac((p.xx + p.yz) * p.zy);
			}
			
			float3 hsv2rgb(float3 c) {
				return ((clamp(abs(frac(c.x+float3(0,2./3,1./3))*6-3)-1,0,1)-1)*c.y+1)*c.z;
			}
			
			float3 rgb2hsv(float3 c) {
				float4 K = float4(0, -1./3, 2./3, -1);
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
				return mul(createRotationMatrix(angle), uv);
			}
			
			float2 computeScreenSpaceOverlayUV(float3 worldSpacePos) {
				float3 viewSpace = mul(UNITY_MATRIX_V, worldSpacePos - _WorldSpaceCameraPos);
				float2 adjusted = viewSpace.xy / viewSpace.z;
				float width = _Garb_TexelSize.z;
				#if defined(USING_STEREO_MATRICES)
				width *= .5;
				#endif
				float height = _Garb_TexelSize.w;
				
				return .5 * (1 - adjusted * float2((height*(width+1))/(width*(height+1)), 1));
			}
			
			float2 computeSphereUV(float3 worldSpacePos) {
				float3 viewDir = normalize(worldSpacePos - _WorldSpaceCameraPos);
				float lat = acos(viewDir.y);
				float lon = atan2(viewDir.z, viewDir.x);
				lon = fmod(lon + UNITY_PI, UNITY_TWO_PI) - UNITY_PI;
				return 1 - float2(lon, lat) / UNITY_PI;
			}
			
			bool isInMirror() {
				return unity_CameraProjection[2][0] != 0 || unity_CameraProjection[2][1] != 0;
			}
			
			bool isEye(int eyeIndex, bool mirror) {
				if (mirror) {
					return (UNITY_MATRIX_P._13 >= 0) == eyeIndex;
				} else {
					return unity_StereoEyeIndex == eyeIndex;
				}
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
			
			float3 getBlendedColor(float3 b, float3 s, int mode) {
				UNITY_BRANCH switch (mode) {
					case BLENDMODE_MULTIPLY:
						return b * s;
					case BLENDMODE_SCREEN:
						return 1 - (1 - b) * (1 - s);
					case BLENDMODE_OVERLAY:
						return hardLight(s, b);
					case BLENDMODE_ADD:
						return saturate(b + s);
					case BLENDMODE_SUBTRACT:
						return saturate(b - s);
					case BLENDMODE_DIFFERENCE:
						return abs(b - s);
					case BLENDMODE_DIVIDE:
						return saturate(b / s);
					case BLENDMODE_DARKEN:
						return min(b, s);
					case BLENDMODE_LIGHTEN:
						return max(b, s);
					case BLENDMODE_NORMAL:
						return s;
					case BLENDMODE_COLORDODGE:
						return colorDodge(b, s);
					case BLENDMODE_COLORBURN:
						return colorBurn(b, s);
					case BLENDMODE_HARDLIGHT:
						return hardLight(b, s);
					case BLENDMODE_SOFTLIGHT:
						return softLight(b, s);
					case BLENDMODE_EXCLUSION:
						return b + s - 2 * b * s;
					default:
						// should never reach here
						return 0;
				}
			}
			
			float3 blend(float3 b, float3 s, int mode, fixed amount) {
				return lerp(b, getBlendedColor(b, s, mode), amount);
			}
			
			float lerpstep(float x, float y, float s) {
				// prevent NaN edge case
				if (y == x) return step(y, s);
				if (s < x) return 0;
				if (s > y) return 1;
				return (s - x) / (y - x);
			}
			
			fixed calculateEffectAmplitudeFromFalloff(float dist) {
				UNITY_BRANCH switch (_FalloffCurve) {
					case FALLOFF_CURVE_SHARP:
						return 1 - step(_MaxFalloff, dist);
					case FALLOFF_CURVE_LINEAR:
						return 1 - lerpstep(_MinFalloff, _MaxFalloff, dist);
					case FALLOFF_CURVE_SMOOTH:
						return 1 - smoothstep(_MinFalloff, _MaxFalloff, dist);
					default:
						return 1;
				}
			}
			
			v2f vert (appdata v) {
				v2f o;
				
				bool inMirror = isInMirror();
				bool noRender = 
					_MirrorMode == MIRROR_DISABLE && inMirror
					|| _MirrorMode == MIRROR_ONLY && !inMirror
					#if defined(USING_STEREO_MATRICES)
					|| _PlatformSelector == PLATFORM_DESKTOP
					|| _EyeSelector == EYE_LEFT && !isEye(0, inMirror)
					|| _EyeSelector == EYE_RIGHT && !isEye(1, inMirror)
					#else
					|| _PlatformSelector == PLATFORM_VR
					#endif
					;
				
				
				if (noRender) {
					v.vertex.xyz = 1.0e25;
					o = (v2f) 0;
					o.pos = UnityObjectToClipPos(v.vertex);
					return o;
				}
				
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
				float3 viewVec = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz - _WorldSpaceCameraPos;
				float effectDistance = length(viewVec);
				fixed allAmp = calculateEffectAmplitudeFromFalloff(effectDistance);
				
				float VRFix = 1;
				#if defined(USING_STEREO_MATRICES)
				VRFix = .5;
				#else
				_ScreenReprojection = 0;
				#endif
				
				float2 screenSpaceOverlayUV = 0;
				
				UNITY_BRANCH switch (_ProjectionType) {
					case PROJECTION_FLAT:
						screenSpaceOverlayUV = computeScreenSpaceOverlayUV(i.posWorld);
						break;
					case PROJECTION_SPHERE:
						screenSpaceOverlayUV = computeSphereUV(i.posWorld);
						break;
				}
				
				float2 distortion = 0;
				float2 distortionUV = screenSpaceOverlayUV - .5;
				distortionUV = mul(createRotationMatrix(_DistortionMapRotation), distortionUV);
				
				UNITY_BRANCH switch (_DistortionType) {
					case DISTORT_NORMAL:
						distortion = UnpackNormal(tex2Dlod(_BumpMap, float4(TRANSFORM_TEX((distortionUV + _Time.yy * _BumpMapScrollSpeed), _BumpMap) + .5, 0, 0))).xy * _DistortionAmplitude;
						break;
					case DISTORT_MELT:
						{
							float4 meltVal = tex2Dlod(_MeltMap, float4(TRANSFORM_TEX(distortionUV, _MeltMap) + .5, 0, 0));
							float2 motionVector = normalize(2 * meltVal.rg - 1);
							float activationTime = meltVal.b * _MeltActivationScale;
							float speed = meltVal.a * _DistortionAmplitude;
							if (_MeltController >= activationTime) {
								distortion = ((_MeltController - activationTime) * speed) * motionVector;
							}
						}
						break;
				}
				
				distortion *= allAmp * _DistortionMaskOpacity * tex2Dlod(_DistortionMask, float4((TRANSFORM_TEX((screenSpaceOverlayUV - .5), _DistortionMask) + .5), 0, 0)).r;
				distortion = mul(createRotationMatrix(_DistortionRotation), distortion);
				
				
				float4 color = 0;
				UNITY_BRANCH switch (_OverlayImageType) {
					case OVERLAY_IMAGE:
					case OVERLAY_FLIPBOOK:
						{
							bool flipbook = _OverlayImageType == OVERLAY_FLIPBOOK;
							float currentFrame = 0;
							float2 invCR = 1;
							
							float2 uv = screenSpaceOverlayUV;
							
							float2 res = _MainTex_TexelSize.zw, invRes = _MainTex_TexelSize.xy;
							
							if (flipbook) {
								currentFrame = floor(fmod(_FlipbookStartFrame + _Time.y * _FlipbookFPS, _FlipbookTotalFrames));
								float2 cr = float2(_FlipbookColumns, _FlipbookRows);
								invCR = 1 / cr;
								res *= invCR;
								invRes *= cr;
							}
							
							if (_PixelatedSampling) uv = pixelateSamples(res, invRes, uv);
							
							if (_DistortionTarget == DISTORT_TARGET_OVERLAY || _DistortionTarget == DISTORT_TARGET_BOTH) uv += distortion;
							
							uv -= .5;
							uv = mul(createRotationMatrix(_MainTexRotation), uv);
							uv = TRANSFORM_TEX(uv, _MainTex) + .5;
							
							switch (_OverlayBoundaryHandling) {
								case BOUNDARYMODE_CLAMP:
									uv = saturate(uv);
									break;
								case BOUNDARYMODE_REPEAT:
									uv = frac(uv + _Time.yy * _MainTexScrollSpeed);
									break;
							}
							
							if (flipbook) {
								float row = floor(currentFrame * invCR.x);
								float2 offset = float2(currentFrame - row * _FlipbookColumns, _FlipbookRows - row - 1);
								
								uv = frac((uv + offset) * invCR);
							}
							
							if (_OverlayBoundaryHandling == BOUNDARYMODE_SCREEN && (saturate(uv.x) != uv.x || saturate(uv.y) != uv.y)) {
								color = 0;
							} else {
								color = tex2Dlod(_MainTex, float4(uv, 0, 0)) * _OverlayColor;
							}
						}
						break;
					case OVERLAY_CUBEMAP:
						color = texCUBE(_OverlayCubemap, i.cubemapSampler) * _OverlayColor;
						break;
				}
				
				
				float2 displace = float2(_XShake, _YShake) * sin(_Time.yy * float2(_XShakeSpeed, _YShakeSpeed)) * _ShakeAmplitude;
				
				if (_DistortionTarget == DISTORT_TARGET_SCREEN || _DistortionTarget == DISTORT_TARGET_BOTH) displace += distortion;
				
				float2 grabUV;
				if (_ScreenReprojection) {
					grabUV = screenSpaceOverlayUV;
				} else {
					grabUV = i.projPos.xy / i.projPos.w;
				}
				
				if (distance(i.posOrigin.xy, saturate(i.posOrigin.xy)) == 0) {
					grabUV -= i.posOrigin.xy;
					_Zoom = lerp(1, _Zoom, saturate(-dot(normalize(viewVec), UNITY_MATRIX_V[2].xyz)));
					grabUV *= lerp(1, _Zoom, allAmp);
					_Pixelation *= allAmp;
					if (_Pixelation > 0) grabUV = floor(grabUV / _Pixelation) * _Pixelation;
					grabUV += i.posOrigin.xy;
				}
				
				float2 wobbleTiling = i.pos.xy * float2(_XWobbleTiling, _YWobbleTiling);
				displace += float2(_XWobbleAmount, _YWobbleAmount) * sin(_Time.yy * float2(_XWobbleSpeed, _YWobbleSpeed) + wobbleTiling);
				
				
				
				displace.x *= VRFix;
				
				grabUV += allAmp * displace;
				
				float4 grabCol = float4(0, 0, 0, 1);
				
				UNITY_LOOP for (int blurPass = 0; blurPass < _BlurSampling; ++blurPass) {
					float2 blurNoiseRand = hash23(float3(grabUV, (float) blurPass));
					
					blurNoiseRand.x *= UNITY_TWO_PI;
					
					float s, c;
					sincos(blurNoiseRand.x, s, c);
					
					// FIXME: does this line need VRFix? i think it might.
					float2 sampleUV = grabUV + (blurNoiseRand.y * allAmp * _BlurRadius * float2(s, c)) / (_Garb_TexelSize.zw);
					
					float4 col;
					
					UNITY_UNROLL for (int j = 0; j < 3; ++j) {
						float2 multiplier = float2(_ScreenXMultiplier[j] * _ScreenXMultiplier.a, _ScreenYMultiplier[j] * _ScreenYMultiplier.a);
						float2 shift = float2(_ScreenXOffset[j] + _ScreenXOffset.a, _ScreenYOffset[j] + _ScreenYOffset.a);
						shift.x *= VRFix;
						float rotationAngle = _ScreenRotationAngle[j];
						float2 rotationOrigin = float2(_ScreenRotationOriginX[j], _ScreenRotationOriginY[j]);
						
						if (!_ScreenReprojection) rotationAngle = 0;
						
						float2 uv = lerp(sampleUV, shift + multiplier * (rotate(sampleUV - rotationOrigin, rotationAngle) + rotationOrigin), allAmp);
						
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
							if (_ScreenReprojection) {
								col[j] = tex2D(_Garb, uv * float2(VRFix, 1))[j];
							} else {
								col[j] = tex2D(_Garb, uv)[j];
							}
						}
					}
					
					grabCol = lerp(grabCol, col, 1 / (float) (blurPass + 1));
				}
				
				float3 hsv = rgb2hsv(grabCol.rgb) * _HSVMultiply + _HSVAdd;
				hsv.r = frac(hsv.r);
				hsv.g = saturate(hsv.g);
				grabCol.rgb = lerp(grabCol.rgb, hsv2rgb(hsv), allAmp);
				
				// lol one-liner for exposure and shit, GOML
				if (_Burn) grabCol.rgb = lerp(grabCol.rgb, smoothstep(_BurnLow, _BurnHigh, grabCol.rgb), allAmp);
				
				float3 finalScreenColor = lerp(grabCol, float4(1 - grabCol.rgb, grabCol.a), _InversionAmount * allAmp);
				float overlayMask = _OverlayMaskOpacity * tex2Dlod(_OverlayMask, float4(.5+TRANSFORM_TEX((screenSpaceOverlayUV-.5), _OverlayMask), 0, 0)).r;
				finalScreenColor = blend(finalScreenColor, color.rgb, _BlendMode, _BlendAmount * color.a * overlayMask * allAmp);
				
				float overallMask = _OverallEffectMaskOpacity * tex2Dlod(_OverallEffectMask, float4(.5+TRANSFORM_TEX((screenSpaceOverlayUV-.5), _OverallEffectMask), 0, 0)).r;
				finalScreenColor *= lerp(1, _Color.rgb, allAmp);
				float overallMaskFalloff = allAmp;
				if (_OverallEffectMaskBlendMode == BLENDMODE_NORMAL)  overallMaskFalloff = 1 - step(_MaxFalloff, effectDistance);
				finalScreenColor = blend(tex2D(_Garb, i.projPos.xy / i.projPos.w).rgb, finalScreenColor, _OverallEffectMaskBlendMode, overallMask * overallMaskFalloff);
				
				return float4(finalScreenColor, 1);
			}
			ENDCG
		}
	}
	CustomEditor "CancerspaceInspector"
}
