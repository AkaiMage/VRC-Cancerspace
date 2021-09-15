Shader "RedMage/Cancerfree" {
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
		
		//CANCERFREE
		//_BlurRadius ("Blur Radius", Range(0, 50)) = 0
		//_BlurSampling ("Blur Sampling", Range(1, 5)) = 1
		//[Toggle(_)] _AnimatedSampling ("Animated Sampling", Float) = 1
		
		//CANCERFREE
		//_Zoom ("Zoom", Range(-10, 10)) = 1
		//[PowerSlider(2.0)] _Pixelation ("Pixelation", Range(0, 1)) = 0
		
		//CANCERFREE
		//[PowerSlider(2.0)] _XWobbleAmount ("X Amount", Range(0,1)) = 0
		//[PowerSlider(2.0)] _YWobbleAmount ("Y Amount", Range(0,1)) = 0
		//[PowerSlider(2.0)] _XWobbleTiling ("X Tiling", Range(0,3.141592653589793238)) = 0.1
		//[PowerSlider(2.0)] _YWobbleTiling ("Y Tiling", Range(0,3.141592653589793238)) = 0.1
		//[PowerSlider(2.0)] _XWobbleSpeed ("X Speed", Range(0, 100)) = 100
		//[PowerSlider(2.0)] _YWobbleSpeed ("Y Speed", Range(0, 100)) = 100
		
		//CANCERFREE
		//[Enum(Normal, 0, Melt, 1)] _DistortionType ("Distortion Type", Int) = 0
		//[Enum(Screen, 0, Overlay, 1, Both, 2)] _DistortionTarget ("Target", Int) = 0
		//_BumpMap ("Distortion Map (Normal)", 2D) = "bump" {}
		//_MeltMap ("Melt Map", 2D) = "white" {}
		//_DistortionMapRotation ("Map Rotation", Range(0, 360)) = 0
		//_MeltActivationScale ("Activation _Time Scale", Range(0, 3)) = 1
		//_MeltController ("Controller", Range(0, 3)) = 0
		//_DistortionAmplitude ("Amplitude", Range(-1, 1)) = 0.0
		//_DistortionRotation ("Direction Rotation", Range(0, 360)) = 0
		//_BumpMapScrollSpeedX ("Scroll Speed X", Range(-2, 2)) = 0
		//_BumpMapScrollSpeedY ("Scroll Speed Y", Range(-2, 2)) = 0
		//[Toggle(_)] _DistortFlipbook ("Flipbook", Int) = 0
		//_DistortFlipbookTotalFrames ("Total Frames", Int) = 0
		//_DistortFlipbookFPS ("Frames per second", Float) = 1
		//_DistortFlipbookStartFrame ("Start Frame", Int) = 0
		//_DistortFlipbookColumns ("Columns", Int) = 20
		//_DistortFlipbookRows ("Rows", Int) = 20
		
		//CANCERFREE
		//[PowerSlider(2.0)] _XShake ("X Shake", Range(0, 1)) = 0
		//[PowerSlider(2.0)] _YShake ("Y Shake", Range(0, 1)) = 0
		//_XShakeSpeed ("X Shake Speed", Range(0, 300)) = 200
		//_YShakeSpeed ("Y Shake Speed", Range(0, 300)) = 300
		//_ShakeAmplitude ("Shake Amplitude", Range(0, 2)) = 1
		
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
		//CANCERFREE
		//_BlendMode ("Blend Mode", Int) = 0
		
		
		_HueAdd ("Hue Add", Range(-1, 1)) = 0
		_SaturationAdd ("Saturation Add", Range(-1, 1)) = 0
		_ValueAdd ("Value Add", Range(-1, 1)) = 0
		_HueMultiply ("Hue Multiply", Range(-40, 40)) = 1
		_SaturationMultiply ("Saturation Multiply", Range(0, 1)) = 1
		_ValueMultiply ("Value Multiply", Range(0, 5)) = 1
		
		//CANCERFREE
		//_InversionAmount ("Inversion Amount", Range(0,1)) = 0
		//[HDR] _Color ("Screen Color", Color) = (1,1,1,1)
		//CANCERFREE
		//_ScreenColorBlendMode ("Screen Color Blend Mode", Int) = 0
		
		//CANCERFREE
		//[Toggle(_)] _Burn ("Color Burning", Int) = 0
		//_BurnLow ("Color Burn Low", Range(-5, 5)) = 0
		//_BurnHigh ("Color Burn High", Range(-5, 5)) = 1
		
		//CANCERFREE
		//[Enum(Clamp, 0, Repeat, 1, Overlay, 2)] _ScreenBoundaryHandling ("Screen Boundary Handling", Int) = 0
		//[Toggle(_)] _ScreenReprojection ("Screen Reprojection", Int) = 0
		//_ScreenXOffsetR ("Screen X Offset (Red)", Range(-1, 1)) = 0
		//_ScreenXOffsetG ("Screen X Offset (Green)", Range(-1, 1)) = 0
		//_ScreenXOffsetB ("Screen X Offset (Blue)", Range(-1, 1)) = 0
		//_ScreenXOffsetA ("Screen X Offset (All)", Range(-1, 1)) = 0
		//_ScreenYOffsetR ("Screen Y Offset (Red)", Range(-1, 1)) = 0
		//_ScreenYOffsetG ("Screen Y Offset (Green)", Range(-1, 1)) = 0
		//_ScreenYOffsetB ("Screen Y Offset (Blue)", Range(-1, 1)) = 0
		//_ScreenYOffsetA ("Screen Y Offset (All)", Range(-1, 1)) = 0
		//_ScreenXMultiplierR ("Screen X Multiplier (Red)", Range(-5, 5)) = 1
		//_ScreenXMultiplierG ("Screen X Multiplier (Green)", Range(-5, 5)) = 1
		//_ScreenXMultiplierB ("Screen X Multiplier (Blue)", Range(-5, 5)) = 1
		//_ScreenXMultiplierA ("Screen X Multiplier (All)", Range(-5, 5)) = 1
		//_ScreenYMultiplierR ("Screen Y Multiplier (Red)", Range(-5, 5)) = 1
		//_ScreenYMultiplierG ("Screen Y Multiplier (Green)", Range(-5, 5)) = 1
		//_ScreenYMultiplierB ("Screen Y Multiplier (Blue)", Range(-5, 5)) = 1
		//_ScreenYMultiplierA ("Screen Y Multiplier (All)", Range(-5, 5)) = 1
		//_ScreenRotationAngle ("Screen Rotation Angle", Range(-360, 360)) = 0
		
		[Toggle(_)] _ParticleSystem ("Is on Particle System?", Float) = 0
		[Toggle(_)] _LifetimeFalloff ("Lifetime Falloff", Int) = 0
		[Enum(Sharp, 0, Linear, 1, Smooth, 2)] _LifetimeFalloffCurve ("Curve", Int) = 1
		_LifetimeMinFalloff ("Min Falloff", Range(0,1)) = 0
		_LifetimeMaxFalloff ("Max Falloff", Range(0,1)) = 1
		
		//CANCERFREE
		//_DistortionMask ("Distortion Mask", 2D) = "white" {}
		//_DistortionMaskOpacity ("Opacity", Range(0, 1)) = 1
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
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSource ("Blend Source", Int) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDestination ("Blend Destination", Int) = 10
		[Enum(UnityEngine.Rendering.BlendOp)] _BlendOp ("Blend Mode", Int) = 21
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
		
		BlendOp [_BlendOp]
		Blend [_BlendSource] [_BlendDestination]

		Pass {
			CGPROGRAM
			#define CANCERFREE
			#define SCREENTEXNAME _Garb
			#define SCREEN_SIZE (float4(rcp(_ScreenParams.xy), _ScreenParams.xy))
			sampler2D _Garb;
			float4 _Garb_TexelSize;
			#include "Cancercore.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
			ENDCG
		}
	}
	CustomEditor "CancerspaceInspector"
}
