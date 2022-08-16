#ifndef CS_UV_CGINC
#define CS_UV_CGINC

#include "UnityCG.cginc"
#include "CSTransform.cginc"

float2 pixelateSamples(float2 res, float2 invRes, float2 uv) {
	uv *= res;
	return (floor(uv) + smoothstep(0, fwidth(uv), frac(uv)) - .5) * invRes;
}

float2 computeScreenSpaceOverlayUV(float3 worldSpacePos, float2 screenRes) {
	float3 viewSpace = mul(UNITY_MATRIX_V, worldSpacePos - _WorldSpaceCameraPos);
	float2 adjusted = viewSpace.xy / viewSpace.z;
	float width = screenRes.x;
#if defined(UNITY_SINGLE_PASS_STEREO)
	width *= .5;
#endif
	float height = screenRes.y;
	
	return .5 * (1 - adjusted * float2((height*(width+1))/(width*(height+1)), 1));
}

float2 computeSphereUV(float3 worldSpacePos) {
	float3 viewDir = normalize(worldSpacePos - _WorldSpaceCameraPos);
	float lat = acos(viewDir.y);
	float lon = atan2(viewDir.z, viewDir.x);
	lon = fmod(lon + UNITY_PI, UNITY_TWO_PI) - UNITY_PI;
	return 1 - float2(lon, lat) / UNITY_PI;
}

float2 calculateScreenUVs(int projectionType, float3 posWorld, float2 meshUV, float3 triplanarWorld, float3 triplanarNormal, float2 screenRes) {
	float2 screenSpaceOverlayUV = 0;
	
	UNITY_BRANCH switch (projectionType) {
		case PROJECTION_FLAT:
			screenSpaceOverlayUV = computeScreenSpaceOverlayUV(posWorld, screenRes);
			break;
		case PROJECTION_SPHERE:
			screenSpaceOverlayUV = computeSphereUV(posWorld);
			break;
		case PROJECTION_MESH:
			screenSpaceOverlayUV = meshUV;
			break;
		case PROJECTION_WALLS: {
			float3 rd = normalize(posWorld - _WorldSpaceCameraPos);
			float bot = dot(rd, float3(1, 0, 0));
			bot = sign(bot) * max(abs(bot), 3e-3);
			screenSpaceOverlayUV = (rd / bot).yz;
			break;
		}
		case PROJECTION_TRIPLANAR: {
			triplanarNormal = abs(triplanarNormal);
			
			screenSpaceOverlayUV = 
				step(triplanarNormal.y, triplanarNormal.x) * step(triplanarNormal.z, triplanarNormal.x) * triplanarWorld.zy + 
				step(triplanarNormal.x, triplanarNormal.y) * step(triplanarNormal.z, triplanarNormal.y) * triplanarWorld.xz + 
				step(triplanarNormal.x, triplanarNormal.z) * step(triplanarNormal.y, triplanarNormal.z) * triplanarWorld.xy;
			break;
		}
	}
	
	return screenSpaceOverlayUV;
}

#endif
