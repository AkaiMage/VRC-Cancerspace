#ifndef CS_BLENDING_CGINC
#define CS_BLENDING_CGINC

#include "UnityCG.cginc"
#include "CSEnums.cginc"

float3 unboundedSmoothstep(float a, float b, float3 x) {
	float3 t = (x - a) / (b - a);
	return t * t * (3.0 - (2.0 * t));
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

#endif
