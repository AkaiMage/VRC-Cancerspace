#ifndef CS_DISCRIMINATE_CGINC
#define CS_DISCRIMINATE_CGINC

#include "UnityCG.cginc"

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

#endif
