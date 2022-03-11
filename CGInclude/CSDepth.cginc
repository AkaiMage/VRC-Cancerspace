#ifndef CS_DEPTH_CGINC
#define CS_DEPTH_CGINC

#include "UnityCG.cginc"

float4 CalculateFrustumCorrection() {
	float x1 = -UNITY_MATRIX_P._31 / (UNITY_MATRIX_P._11 * UNITY_MATRIX_P._34);
	float x2 = -UNITY_MATRIX_P._32 / (UNITY_MATRIX_P._22 * UNITY_MATRIX_P._34);
	return float4(x1, x2, 0, UNITY_MATRIX_P._33 / UNITY_MATRIX_P._34 + x1 * UNITY_MATRIX_P._13 + x2 * UNITY_MATRIX_P._23);
}

float CorrectedLinearEyeDepth(float z, float B) {
	return rcp(z / UNITY_MATRIX_P._34 + B);
}

float calculateCameraDepth(float2 screenPos, float4 worldDir, float perspectiveDivide) {
	float z = SAMPLE_DEPTH_TEXTURE_LOD(_CameraDepthTexture, float4(screenPos * perspectiveDivide, 0, 0));
	return CorrectedLinearEyeDepth(z, worldDir.w);
}

#endif
