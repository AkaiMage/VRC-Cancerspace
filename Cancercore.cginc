#ifndef CANCERCORE_CGINC
#define CANCERCORE_CGINC

#include "AutoLight.cginc"

struct appdata {
	float4 vertex : POSITION;
	float3 normal : NORMAL;
	float4 uv : TEXCOORD0;
	float4 uv2 : TEXCOORD1;
	float4 color : COLOR;
	
	UNITY_VERTEX_INPUT_INSTANCE_ID
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
	
	UNITY_VERTEX_OUTPUT_STEREO
};

#include "CGInclude/CSProps.cginc"
#include "CGInclude/CSEnums.cginc"
#include "CGInclude/CSBlending.cginc"
#include "CGInclude/CSUV.cginc"
#include "CGInclude/CSTransform.cginc"
#include "CGInclude/CSDepth.cginc"
#include "CGInclude/CSDiscriminate.cginc"
#include "CGInclude/CSFalloff.cginc"

//CANCERFREE
float4 sampleBumpMap(float4 uv) {
#ifdef CANCERFREE
	return ((float4)0);
#else
	return tex2Dlod(_BumpMap, uv);
#endif
}
float4 sampleMeltMap(float4 uv) {
#ifdef CANCERFREE
	return ((float4)0);
#else
	return tex2Dlod(_MeltMap, uv);
#endif
}
float4 sampleDistortionMask(float4 uv) {
#ifdef CANCERFREE
	return ((float4)0);
#else
	return tex2Dlod(_DistortionMask, uv);
#endif
}

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
			uv = frac(uv + frac(_Time.yy * uvScrollSpeed));
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
				distortion = UnpackNormal(sampleBumpMap(float4(distortionUV, 0, 0))).xy * _DistortionAmplitude;
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
				float4 meltVal = sampleMeltMap(float4(distortionUV, 0, 0));
				float2 motionVector = normalize(2 * meltVal.rg - 1);
				float activation_Time = meltVal.b * _MeltActivationScale;
				float speed = meltVal.a * _DistortionAmplitude;
				if (_MeltController >= activation_Time) {
					distortion = ((_MeltController - activation_Time) * speed) * motionVector;
				}
			}
			break;
	}
	
	distortion *= falloffAmplitude * _DistortionMaskOpacity * sampleDistortionMask(float4((TRANSFORM_TEX((screenSpaceOverlayUV - .5), _DistortionMask) + .5), 0, 0)).r;
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
					return tex2Dlod(_MainTex, float4(uv, 0, 0)) * _OverlayColor;
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
	
	// SPS-I setup
	UNITY_SETUP_INSTANCE_ID(v);
	UNITY_INITIALIZE_OUTPUT(v2f, o);
	UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
	
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
	
#ifndef CANCERFREE
	UNITY_BRANCH if (!_ScreenReprojection)
#endif
	{
		int projectionType = _ProjectionType;
		if (projectionType == PROJECTION_TRIPLANAR) projectionType = PROJECTION_FLAT;
		
		float2 screenUV = calculateScreenUVs(
			_ProjectionType, 
			rotateProjectionWorld(o.posWorld, _ProjectionRot), 
			v.uv, 
			0, 
			0, 
			SCREEN_SIZE.zw
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
	// SPS-I setup
	UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

	float timeCircularMod = fmod(_Time.y, UNITY_TWO_PI);
	
	float3 viewVec = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz - _WorldSpaceCameraPos;
	float effectDistance = i.uv.z;
	float particleAge01 = i.uv.w;
	
	float depth = calculateCameraDepth(i.depthPos.xy, i.worldDir, rcp(i.pos.w));
	
	float VRFix = 1;
#if defined(UNITY_SINGLE_PASS_STEREO)
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
		SCREEN_SIZE.zw
	);
	
	fixed allAmp = calculateFalloffAmplitude(effectDistance, screenSpaceOverlayUV, i.color, depth, particleAge01);
	float2 distortion = calculateDistortion(allAmp, screenSpaceOverlayUV);
	float4 color = calculateOverlayColor(screenSpaceOverlayUV, distortion, i.cubemapSampler);
	
	float2 grabUV = _ScreenReprojection ? screenSpaceOverlayUV : (i.projPos.xy / i.projPos.w);
	
	float3 originPos = ComputeGrabScreenPos(UnityObjectToClipPos(float4(0,0,0,1))).xyw;
	originPos.xy /= originPos.z;
	if (distance(originPos.xy, saturate(originPos.xy)) == 0) {
		grabUV -= originPos.xy;
		float zoomAmt = lerp(1, _Zoom, saturate(-dot(normalize(viewVec), UNITY_MATRIX_V[2].xyz)));
		grabUV *= lerp(1, zoomAmt, allAmp);
		grabUV += originPos.xy;
	}
	
	float pixelationAmt = _Pixelation * allAmp;
	if (pixelationAmt > 0) grabUV = floor(grabUV / pixelationAmt) * pixelationAmt;
	
	float2 displace = _Shake * sin(timeCircularMod * _ShakeSpeed) * _ShakeAmplitude;
	displace += _WobbleAmount * sin(timeCircularMod * _WobbleSpeed + i.pos.xy * _WobbleTiling);
	if (_DistortionTarget == DISTORT_TARGET_SCREEN || _DistortionTarget == DISTORT_TARGET_BOTH) displace += distortion;
	grabUV += allAmp * displace * float2(VRFix, 1);
	
	float4 grabCol = float4(0, 0, 0, 1);
	
#ifndef CANCERFREE
	for (int blurPass = 0; blurPass < _BlurSampling; ++blurPass) {
		float2 blurNoiseRand = hash23(float3(grabUV, (float) blurPass));
		
		float s, c;
		sincos(blurNoiseRand.x * UNITY_TWO_PI, s, c);
		
		// FIXME: does this line need VRFix? i think it might.
		float2 sampleUV = grabUV + (blurNoiseRand.y * allAmp * _BlurRadius * float2(s, c)) / (SCREEN_SIZE.zw);
		
		float4 col = 0;
		
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
				col.a = max(col.a, color.a);
			} else {
				UNITY_BRANCH if (_ScreenReprojection) {
					float4 testColor = UNITY_SAMPLE_SCREENSPACE_TEXTURE(SCREENTEXNAME, uv * float2(VRFix, 1));
					col[j] = testColor[j];
					col.a = max(col.a, testColor.a);
				} else {
					float4 testColor = UNITY_SAMPLE_SCREENSPACE_TEXTURE(SCREENTEXNAME, uv);
					col[j] = testColor[j];
					col.a = max(col.a, testColor.a);
				}
			}
		}
		
		grabCol = lerp(grabCol, col, 1 / (float) (blurPass + 1));
	}
#endif

	//CANCERFREE
	float overlayMask = _OverlayMaskOpacity * tex2Dlod(_OverlayMask, float4(.5+TRANSFORM_TEX((screenSpaceOverlayUV-.5), _OverlayMask), 0, 0)).r;
	float overallMask = _OverallEffectMaskOpacity * tex2Dlod(_OverallEffectMask, float4(.5+TRANSFORM_TEX((screenSpaceOverlayUV-.5), _OverallEffectMask), 0, 0)).r;
#ifdef CANCERFREE
	return float4(color.rgb, color.a * _BlendAmount * overlayMask * overallMask * allAmp);
#else
	float3 hsv = rgb2hsv(grabCol.rgb) * _HSVMultiply + _HSVAdd;
	hsv.r = frac(hsv.r);
	hsv.g = saturate(hsv.g);
	grabCol.rgb = lerp(grabCol.rgb, hsv2rgb(hsv), allAmp);
	
	// lol one-liner for exposure and shit, GOML
	if (_Burn) grabCol.rgb = lerp(grabCol.rgb, unboundedSmoothstep(_BurnLow, _BurnHigh, grabCol.rgb), allAmp);

	float finalScreenAlpha = grabCol.a;
	finalScreenAlpha *= _Color.a;
	finalScreenAlpha *= color.a;
	
	float3 finalScreenColor = lerp(grabCol, float4(1 - grabCol.rgb, grabCol.a), _InversionAmount * allAmp);
	finalScreenColor = blend(finalScreenColor, color.rgb, _BlendMode, _BlendAmount * color.a * overlayMask * allAmp);
	finalScreenColor = blend(finalScreenColor, _Color.rgb, _ScreenColorBlendMode, allAmp);
	float overallMaskFalloff = allAmp;
	if (_OverallEffectMaskBlendMode == BLENDMODE_NORMAL)  overallMaskFalloff = 1 - step(_MaxFalloff, effectDistance);
	finalScreenColor = blend(UNITY_SAMPLE_SCREENSPACE_TEXTURE(SCREENTEXNAME, i.projPos.xy / i.projPos.w).rgb, finalScreenColor, _OverallEffectMaskBlendMode, overallMask * overallMaskFalloff);
	
	return float4(finalScreenColor, finalScreenAlpha);
#endif
}

#endif
