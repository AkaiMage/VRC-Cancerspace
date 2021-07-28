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
		
		[Enum(Flat, 0, Sphere, 1, Mesh, 2, Walls, 3, Triplanar, 4)] _ProjectionType ("Projection Type", Int) = 0
		_ProjectionRotX ("Rotation X", Range(-360, 360)) = 0
		_ProjectionRotY ("Rotation Y", Range(-360, 360)) = 0
		_ProjectionRotZ ("Rotation Z", Range(-360, 360)) = 0
		
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
		[Toggle(_)] _DepthFalloff ("Camera Depth Falloff", Int) = 0
		_DepthMinFalloff ("Min Distance", Float) = 30
		_DepthMaxFalloff ("Max Distance", Float) = 60
		[Enum(Sharp, 0, Linear, 1, Smooth, 2)] _DepthFalloffCurve ("Curve", Int) = 2
		[Toggle(_)] _ColorFalloff ("Vertex-Color Falloff", Int) = 0
		_ColorMinFalloff ("Min Falloff", Range(0, 1)) = 0
		_ColorMaxFalloff ("Max Falloff", Range(0, 1)) = 1
		[Enum(Sharp, 0, Linear, 1, Smooth, 2)] _ColorFalloffCurve ("Curve", Int) = 2
		[Enum(Red, 0, Green, 1, Blue, 2, Alpha, 3)] _ColorChannelForFalloff ("Color Channel to use", Int) = 3
		
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
		_MeltActivationScale ("Activation _Time Scale", Range(0, 3)) = 1
		_MeltController ("Controller", Range(0, 3)) = 0
		_DistortionAmplitude ("Amplitude", Range(-1, 1)) = 0.0
		_DistortionRotation ("Direction Rotation", Range(0, 360)) = 0
		_BumpMapScrollSpeedX ("Scroll Speed X", Range(-2, 2)) = 0
		_BumpMapScrollSpeedY ("Scroll Speed Y", Range(-2, 2)) = 0
		[Toggle(_)] _DistortFlipbook ("Flipbook", Int) = 0
		_DistortFlipbookTotalFrames ("Total Frames", Int) = 0
		_DistortFlipbookFPS ("Frames per second", Float) = 1
		_DistortFlipbookStartFrame ("Start Frame", Int) = 0
		_DistortFlipbookColumns ("Columns", Int) = 20
		_DistortFlipbookRows ("Rows", Int) = 20
		
		[PowerSlider(2.0)] _XShake ("X Shake", Range(0, 1)) = 0
		[PowerSlider(2.0)] _YShake ("Y Shake", Range(0, 1)) = 0
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
		_MainTexMaxDistance ("Max Distance", Range(0.003, .9)) = 0.003
        [Toggle(_)] _WallsUvFlip ("Flip UV for the opposite side", Int) = 0
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
		_ScreenColorBlendMode ("Screen Color Blend Mode", Int) = 0
		
		[Toggle(_)] _Burn ("Color Burning", Int) = 0
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
		_ScreenRotationAngle ("Screen Rotation Angle", Range(-360, 360)) = 0
		
		[Toggle(_)] _ParticleSystem ("Is on Particle System?", Float) = 0
		[Toggle(_)] _LifetimeFalloff ("Lifetime Falloff", Int) = 0
		[Enum(Sharp, 0, Linear, 1, Smooth, 2)] _LifetimeFalloffCurve ("Curve", Int) = 1
		_LifetimeMinFalloff ("Min Falloff", Range(0,1)) = 0
		_LifetimeMaxFalloff ("Max Falloff", Range(0,1)) = 1
		
		_DistortionMask ("Distortion Mask", 2D) = "white" {}
		_DistortionMaskOpacity ("Opacity", Range(0, 1)) = 1
		_OverlayMask ("Overlay Mask", 2D) = "white" {}
		_OverlayMaskOpacity ("Opacity", Range(0, 1)) = 1
		_OverallEffectMask ("Entire Effect Mask", 2D) = "white" {}
		_OverallEffectMaskOpacity ("Opacity", Range(0, 1)) = 1
		_OverallAmplitudeMask ("Entire Effect Amplitude Mask", 2D) = "white" {}
		_OverallAmplitudeMaskOpacity ("Opacity", Range(0, 1)) = 1
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
			
			
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 uv : TEXCOORD0;
				float4 uv2 : TEXCOORD1;
				float4 color : COLOR;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float3 posWorld : TEXCOORD0;
				float4 projPos : TEXCOORD1;
				float4 depthPos : TEXCOORD2;
				float3 cubemapSampler : TEXCOORD3;
				float4 uv : TEXCOORD4;
				float4 worldDir : TEXCOORD5;
				float4 color : TEXCOORD6;
			};
			
			#include "CGInclude/CSProps.cginc"
			
			sampler2D _Garb;
			float4 _Garb_TexelSize;

			#include "CGInclude/CSEnums.cginc"
			#include "CGInclude/CSBlending.cginc"
			#include "CGInclude/CSUV.cginc"
			#include "CGInclude/CSTransform.cginc"
			#include "CGInclude/CSDepth.cginc"
			#include "CGInclude/CSDiscriminate.cginc"
			#include "CGInclude/CSFalloff.cginc"
			
			float2 hash23(float3 p) {
				if (_AnimatedSampling) p.z += frac(_Time.z) * 4;
				p = frac(p * float3(400, 450, .1));
				p += dot(p, p.yzx + 20);
				return frac((p.xx + p.yz) * p.zy);
			}
			
			float2 calculateUVsWithFlipbookParameters(float2 uv, float2 distortion, bool pixelated, bool flipbook, float4 texelSizes, float startFrame, float fps, float totalFrames, float2 cr, float uvRot, float2 uvScrollSpeed, float4 uvST, int boundaryHandling) {
				float currentFrame = 0;
				float2 invCR = 1;
				
				float2 res = texelSizes.zw, invRes = texelSizes.xy;
				
				if (flipbook) {
					currentFrame = floor(fmod(startFrame + fmod(_Time.y * fps, totalFrames), totalFrames));
					invCR = 1 / cr;
					res *= invCR;
					invRes *= cr;
				}
				
				if (pixelated) uv = pixelateSamples(res, invRes, uv);
				
				if (_DistortionTarget == DISTORT_TARGET_OVERLAY || _DistortionTarget == DISTORT_TARGET_BOTH) uv += distortion;
				
				uv -= .5;
				uv = mul(createRotationMatrix(uvRot), uv);
				uv = uv * uvST.xy + uvST.zw + .5;
				
				switch (boundaryHandling) {
					case BOUNDARYMODE_CLAMP:
						uv = saturate(uv);
						break;
					case BOUNDARYMODE_REPEAT:
						uv += _Time.yy * uvScrollSpeed;
						break;
				}
				
				if (flipbook) {
					float row = floor(currentFrame * invCR.x);
					float2 offset = float2(currentFrame - row * cr.x, cr.y - row - 1);
					
					uv = frac((uv + offset) * invCR);
				}
				
				return uv;
			}
			
			fixed calculateFalloffAmplitude(float dist, float2 screenUV, float4 color, float depth, float particleAge01) {
				screenUV -= .5;
				fixed4 amplitudeMaskContribution = tex2Dlod(_OverallAmplitudeMask, float4(TRANSFORM_TEX(screenUV, _OverallAmplitudeMask) + .5, 0, 0));
				
				fixed ageContribution = 1;
				if (_LifetimeFalloff) {
					ageContribution = calculateEffectAmplitudeFromFalloff(particleAge01, _LifetimeFalloffCurve, _LifetimeMinFalloff, _LifetimeMaxFalloff);
				}
				
				fixed depthContribution = 1;
				if (_DepthFalloff && depth != -1234) {
					depthContribution = calculateEffectAmplitudeFromFalloff(depth, _DepthFalloffCurve, _DepthMinFalloff, _DepthMaxFalloff);
				}

				fixed colorContribution = 1;
				if (_ColorFalloff) {
					colorContribution = calculateEffectAmplitudeFromFalloff(color[_ColorChannelForFalloff], _ColorFalloffCurve, _ColorMinFalloff, _ColorMaxFalloff);
				}
				
				return calculateEffectAmplitudeFromFalloff(dist, _FalloffCurve, _MinFalloff, _MaxFalloff) * amplitudeMaskContribution.r * amplitudeMaskContribution.a * _OverallAmplitudeMaskOpacity * depthContribution * ageContribution * colorContribution;
			}
			
			float2 calculateDistortion(float falloffAmplitude, float2 screenSpaceOverlayUV) {
				float2 distortion = 0;
				UNITY_BRANCH switch (_DistortionType) {
					case DISTORT_NORMAL:
						{
							float2 distortionUV = calculateUVsWithFlipbookParameters(
								screenSpaceOverlayUV,
								0,
								false,
								_DistortFlipbook,
								_BumpMap_TexelSize,
								_DistortFlipbookStartFrame,
								_DistortFlipbookFPS,
								_DistortFlipbookTotalFrames,
								float2(_DistortFlipbookColumns, _DistortFlipbookRows),
								_DistortionMapRotation,
								_BumpMapScrollSpeed,
								_BumpMap_ST,
								BOUNDARYMODE_REPEAT);
							distortion = UnpackNormal(tex2Dlod(_BumpMap, float4(distortionUV, 0, 0))).xy * _DistortionAmplitude;
						}
						break;
					case DISTORT_MELT:
						{
							float2 distortionUV = calculateUVsWithFlipbookParameters(
								screenSpaceOverlayUV,
								0,
								false,
								_DistortFlipbook,
								_MeltMap_TexelSize,
								_DistortFlipbookStartFrame,
								_DistortFlipbookFPS,
								_DistortFlipbookTotalFrames,
								float2(_DistortFlipbookColumns, _DistortFlipbookRows),
								_DistortionMapRotation,
								0,
								_MeltMap_ST,
								BOUNDARYMODE_REPEAT);
							float4 meltVal = tex2Dlod(_MeltMap, float4(distortionUV, 0, 0));
							float2 motionVector = normalize(2 * meltVal.rg - 1);
							float activation_Time = meltVal.b * _MeltActivationScale;
							float speed = meltVal.a * _DistortionAmplitude;
							if (_MeltController >= activation_Time) {
								distortion = ((_MeltController - activation_Time) * speed) * motionVector;
							}
						}
						break;
				}
				
				distortion *= falloffAmplitude * _DistortionMaskOpacity * tex2Dlod(_DistortionMask, float4((TRANSFORM_TEX((screenSpaceOverlayUV - .5), _DistortionMask) + .5), 0, 0)).r;
				distortion = mul(createRotationMatrix(_DistortionRotation), distortion);
				return distortion;
			}
			
			float4 calculateOverlayColor(float2 screenSpaceOverlayUV, float2 distortion, float3 cubemapSampler) {
				float4 color = 0;
				UNITY_BRANCH switch (_OverlayImageType) {
					case OVERLAY_IMAGE:
					case OVERLAY_FLIPBOOK:
						{
							float2 uv = calculateUVsWithFlipbookParameters(
								screenSpaceOverlayUV, 
								distortion, 
								_PixelatedSampling,
								_OverlayImageType == OVERLAY_FLIPBOOK, 
								_MainTex_TexelSize, 
								_FlipbookStartFrame, 
								_FlipbookFPS, 
								_FlipbookTotalFrames, 
								float2(_FlipbookColumns, _FlipbookRows), 
								_MainTexRotation, 
								_MainTexScrollSpeed, 
								_MainTex_ST,
								_OverlayBoundaryHandling);
							
							if (_OverlayBoundaryHandling == BOUNDARYMODE_SCREEN && (saturate(uv.x) != uv.x || saturate(uv.y) != uv.y)) {
								return 0;
							} else {
								return tex2D(_MainTex, uv) * _OverlayColor;
							}
						}
					case OVERLAY_CUBEMAP:
						return texCUBE(_OverlayCubemap, cubemapSampler) * _OverlayColor;
					default:
						return 0;
				}
			}
			
			v2f vert (appdata v) {
				v2f o;
				
				float2 uv = v.uv.xy;
				float3 particleCenter = float3(v.uv.zw, v.uv2.x);
				float particleAge01 = v.uv2.y;
				
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
				
				v.vertex.xyz = rotateXYZ(v.vertex.xyz, _ObjectRotation);
				v.vertex.xyz *= _ObjectScale;
				v.vertex.xyz += _Puffiness * v.normal;
				
				v.vertex.xyz += _ObjectPosition;
				
				o.posWorld = mul(unity_ObjectToWorld, v.vertex).xyz;
				float4 vertexIntended = UnityObjectToClipPos(v.vertex);
				o.projPos = ComputeGrabScreenPos(vertexIntended);
				o.depthPos = ComputeScreenPos(vertexIntended);
				o.worldDir.xyz = o.posWorld - _WorldSpaceCameraPos;
				o.worldDir.w = dot(vertexIntended, CalculateFrustumCorrection());
				
				float4 viewPos = float4(UnityWorldToViewPos(float4(o.posWorld, 1)), 1);
				
				float distanceForFalloff = 0;
				if (_ParticleSystem) {
					distanceForFalloff = distance(_WorldSpaceCameraPos, particleCenter);//mul(unity_ObjectToWorld, float4(particleCenter, 1)).xyz);
				} else {
					distanceForFalloff = distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz);
				}
				
				UNITY_BRANCH if (!_ScreenReprojection) {
					int projectionType = _ProjectionType;
					if (projectionType == PROJECTION_TRIPLANAR) projectionType = PROJECTION_FLAT;
					
					float2 screenUV = calculateScreenUVs(
						_ProjectionType, 
						rotateProjectionWorld(o.posWorld, _ProjectionRot), 
						v.uv, 
						0, 
						0, 
						_Garb_TexelSize.zw
					);
					
					float rotation = calculateFalloffAmplitude(distanceForFalloff, screenUV, v.color, -1234, particleAge01) * _ScreenRotationAngle;
					viewPos.xy = rotate(viewPos.xy, rotation);
					o.posWorld = rotateAxis(o.posWorld, UNITY_MATRIX_IT_MV[2].xyz, rotation);
				}
				
				o.pos = UnityViewToClipPos(viewPos);
				o.cubemapSampler = rotateXYZ(o.posWorld - _WorldSpaceCameraPos, _OverlayCubemapRotation + fmod(_Time.y * _OverlayCubemapSpeed, 360));
				
				o.uv.xy = v.uv.xy;
				o.uv.z = distanceForFalloff;
				o.uv.w = particleAge01;
				o.color = v.color;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target {
				float timeCircularMod = fmod(_Time.y, UNITY_TWO_PI);
				
				float3 viewVec = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz - _WorldSpaceCameraPos;
				float effectDistance = i.uv.z;
				float particleAge01 = i.uv.w;
				
				float depth = calculateCameraDepth(i.depthPos.xy, i.worldDir, rcp(i.pos.w));
				
				float VRFix = 1;
				#if defined(USING_STEREO_MATRICES)
				VRFix = .5;
				#endif
				
				float3 triplanarWorld = depth * normalize(i.posWorld - _WorldSpaceCameraPos) + _WorldSpaceCameraPos;
				
				float3 triplanarNormal;
				if (isInMirror()) triplanarNormal = cross(ddx(triplanarWorld), ddy(triplanarWorld));
				else triplanarNormal = cross(-ddx(triplanarWorld), ddy(triplanarWorld));
				triplanarNormal = normalize(triplanarNormal);
	
				float2 screenSpaceOverlayUV = calculateScreenUVs(
					_ProjectionType, 
					rotateProjectionWorld(i.posWorld, _ProjectionRot), 
					i.uv.xy, 
					triplanarWorld, 
					triplanarNormal, 
					_Garb_TexelSize.zw
				);
				
				fixed allAmp = calculateFalloffAmplitude(effectDistance, screenSpaceOverlayUV, i.color, depth, particleAge01);
				float2 distortion = calculateDistortion(allAmp, screenSpaceOverlayUV);
				float4 color = calculateOverlayColor(screenSpaceOverlayUV, distortion, i.cubemapSampler);
				
				float2 grabUV = _ScreenReprojection ? screenSpaceOverlayUV : (i.projPos.xy / i.projPos.w);
				
				float3 originPos = ComputeGrabScreenPos(UnityObjectToClipPos(float4(0,0,0,1))).xyw;
				originPos.xy /= originPos.z;
				if (distance(originPos.xy, saturate(originPos.xy)) == 0) {
					grabUV -= originPos.xy;
					_Zoom = lerp(1, _Zoom, saturate(-dot(normalize(viewVec), UNITY_MATRIX_V[2].xyz)));
					grabUV *= lerp(1, _Zoom, allAmp);
					grabUV += originPos.xy;
				}
				_Pixelation *= allAmp;
				if (_Pixelation > 0) grabUV = floor(grabUV / _Pixelation) * _Pixelation;
				
				float2 displace = _Shake * sin(timeCircularMod * _ShakeSpeed) * _ShakeAmplitude;
				displace += _WobbleAmount * sin(timeCircularMod * _WobbleSpeed + i.pos.xy * _WobbleTiling);
				if (_DistortionTarget == DISTORT_TARGET_SCREEN || _DistortionTarget == DISTORT_TARGET_BOTH) displace += distortion;
				grabUV += allAmp * displace * float2(VRFix, 1);
				
				float4 grabCol = float4(0, 0, 0, 1);
				
				UNITY_LOOP for (int blurPass = 0; blurPass < _BlurSampling; ++blurPass) {
					float2 blurNoiseRand = hash23(float3(grabUV, (float) blurPass));
					
					float s, c;
					sincos(blurNoiseRand.x * UNITY_TWO_PI, s, c);
					
					// FIXME: does this line need VRFix? i think it might.
					float2 sampleUV = grabUV + (blurNoiseRand.y * allAmp * _BlurRadius * float2(s, c)) / (_Garb_TexelSize.zw);
					
					float4 col;
					
					UNITY_UNROLL for (int j = 0; j < 3; ++j) {
						float2 multiplier = float2(_ScreenXMultiplier[j] * _ScreenXMultiplier.a, _ScreenYMultiplier[j] * _ScreenYMultiplier.a);
						float2 shift = float2(_ScreenXOffset[j] + _ScreenXOffset.a, _ScreenYOffset[j] + _ScreenYOffset.a);
						shift.x *= VRFix;
						
						float2 uv = sampleUV - .5;
						UNITY_BRANCH if (_ScreenReprojection) {
							uv = rotate(uv, _ScreenRotationAngle * allAmp);
						}
						uv = lerp(uv, shift + multiplier * uv, allAmp) + .5;
						
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
							UNITY_BRANCH if (_ScreenReprojection) {
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
				if (_Burn) grabCol.rgb = lerp(grabCol.rgb, unboundedSmoothstep(_BurnLow, _BurnHigh, grabCol.rgb), allAmp);
				
				float3 finalScreenColor = lerp(grabCol, float4(1 - grabCol.rgb, grabCol.a), _InversionAmount * allAmp);
				float overlayMask = _OverlayMaskOpacity * tex2Dlod(_OverlayMask, float4(.5+TRANSFORM_TEX((screenSpaceOverlayUV-.5), _OverlayMask), 0, 0)).r;
				finalScreenColor = blend(finalScreenColor, color.rgb, _BlendMode, _BlendAmount * color.a * overlayMask * allAmp);
				
				float overallMask = _OverallEffectMaskOpacity * tex2Dlod(_OverallEffectMask, float4(.5+TRANSFORM_TEX((screenSpaceOverlayUV-.5), _OverallEffectMask), 0, 0)).r;
				finalScreenColor = blend(finalScreenColor, _Color.rgb, _ScreenColorBlendMode, allAmp);
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
