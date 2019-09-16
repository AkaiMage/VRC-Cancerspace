#ifndef CS_TRANSFORM_CGINC
#define CS_TRANSFORM_CGINC

#include "UnityCG.cginc"
			
float2x2 createRotationMatrix(float deg) {
	float s, c;
	sincos(deg * (UNITY_PI / 180), s, c);
	return float2x2(c, s, -s, c);
}

float2 rotate(float2 uv, float angle) {
	return mul(createRotationMatrix(angle), uv);
}

float3 rotateAxis(float3 p, float3 k, float theta) {
	// FIXME: this normalize call might not be necessary.
	k = normalize(k);
	
	float s, c;
	sincos(theta * (UNITY_PI / 180), s, c);
	return p * c + cross(k, p) * s + k * dot(k, p) * (1 - c);
}

float3 rotateXYZ(float3 p, float3 r) {
	p.yz = rotate(p.yz, r.x);
	p.xz = rotate(p.xz, r.y);
	p.xy = rotate(p.xy, r.z);
	return p;
}

float3 rotateProjectionWorld(float3 posWorld, float3 r) {
	posWorld -= _WorldSpaceCameraPos;
	float lensq = length(posWorld);
	posWorld /= lensq;
	posWorld = rotateXYZ(posWorld, r);
	posWorld *= lensq;
	posWorld += _WorldSpaceCameraPos;
	return posWorld;
}

#endif
