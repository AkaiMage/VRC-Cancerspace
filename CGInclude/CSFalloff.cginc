#ifndef CS_FALLOFF_CGINC
#define CS_FALLOFF_CGINC

#include "UnityCG.cginc"

float lerpstep(float x, float y, float s) {
	// prevent NaN edge case
	if (y == x) return step(y, s);
	return saturate((s - x) / (y - x));
}

fixed calculateEffectAmplitudeFromFalloff(float dist, int curveType, float minFalloff, float maxFalloff) {
	UNITY_BRANCH switch (curveType) {
		case FALLOFF_CURVE_SHARP:
			return 1 - step(maxFalloff, dist);
		case FALLOFF_CURVE_LINEAR:
			return 1 - lerpstep(minFalloff, maxFalloff, dist);
		case FALLOFF_CURVE_SMOOTH:
			return 1 - smoothstep(minFalloff, maxFalloff, dist);
		default:
			return 1;
	}
}

#endif
