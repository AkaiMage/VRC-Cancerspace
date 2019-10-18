#ifndef CS_PROPS_CGINC
#define CS_PROPS_CGINC

// apparently Unity doesn't animate vector fields properly, so time for some hacky workarounds
#define _ScreenXOffset float4(_ScreenXOffsetR, _ScreenXOffsetG, _ScreenXOffsetB, _ScreenXOffsetA)
#define _ScreenYOffset float4(_ScreenYOffsetR, _ScreenYOffsetG, _ScreenYOffsetB, _ScreenYOffsetA)
#define _ScreenXMultiplier float4(_ScreenXMultiplierR, _ScreenXMultiplierG, _ScreenXMultiplierB, _ScreenXMultiplierA)
#define _ScreenYMultiplier float4(_ScreenYMultiplierR, _ScreenYMultiplierG, _ScreenYMultiplierB, _ScreenYMultiplierA)
#define _HSVAdd float3(_HueAdd, _SaturationAdd, _ValueAdd)
#define _HSVMultiply float3(_HueMultiply, _SaturationMultiply, _ValueMultiply)
#define _ObjectPosition (float3(_ObjectPositionX, _ObjectPositionY, _ObjectPositionZ) + _ObjectPositionA)
#define _ObjectRotation float3(_ObjectRotationX, _ObjectRotationY, _ObjectRotationZ)
#define _ObjectScale (float3(_ObjectScaleX, _ObjectScaleY, _ObjectScaleZ) * _ObjectScaleA)
#define _MainTexScrollSpeed float2(_MainTexScrollSpeedX, _MainTexScrollSpeedY)
#define _BumpMapScrollSpeed float2(_BumpMapScrollSpeedX, _BumpMapScrollSpeedY)
#define _ProjectionRot float3(_ProjectionRotX, _ProjectionRotY, _ProjectionRotZ)
#define _OverlayCubemapRotation float3(_OverlayCubemapRotationX, _OverlayCubemapRotationY, _OverlayCubemapRotationZ)
#define _OverlayCubemapSpeed float3(_OverlayCubemapSpeedX, _OverlayCubemapSpeedY, _OverlayCubemapSpeedZ)
#define _WobbleTiling float2(_XWobbleTiling, _YWobbleTiling)
#define _WobbleAmount float2(_XWobbleAmount, _YWobbleAmount)
#define _WobbleSpeed float2(_XWobbleSpeed, _YWobbleSpeed)
#define _Shake float2(_XShake, _YShake)
#define _ShakeSpeed float2(_XShakeSpeed, _YShakeSpeed)

UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

int _ProjectionType;
float _ProjectionRotX, _ProjectionRotY, _ProjectionRotZ;

float _MinFalloff;
float _MaxFalloff;
int _FalloffCurve;
int _DepthFalloff;
float _DepthMinFalloff;
float _DepthMaxFalloff;
int _DepthFalloffCurve;

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

int _DistortFlipbook;
int _DistortFlipbookRows, _DistortFlipbookColumns;
int _DistortFlipbookStartFrame;
int _DistortFlipbookTotalFrames;
float _DistortFlipbookFPS;

samplerCUBE _OverlayCubemap;
float _OverlayCubemapRotationX, _OverlayCubemapRotationY, _OverlayCubemapRotationZ;
float _OverlayCubemapSpeedX, _OverlayCubemapSpeedY, _OverlayCubemapSpeedZ;

float4 _OverlayColor;
float4 _Color;
int _ScreenColorBlendMode;

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

float _ScreenRotationAngle;

int _ScreenBoundaryHandling;

// blurring method is based on https://www.shadertoy.com/view/XsVBDR

int _BlurSampling;
float _AnimatedSampling;
float _BlurRadius;

int _DistortionType, _DistortionTarget;
sampler2D _BumpMap;
float4 _BumpMap_TexelSize;
float4 _BumpMap_ST;
float _DistortionMapRotation;
float _DistortionAmplitude;
float _DistortionRotation;
float _BumpMapScrollSpeedX, _BumpMapScrollSpeedY;
sampler2D _MeltMap;
float4 _MeltMap_TexelSize;
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
sampler2D _OverallAmplitudeMask;
float4 _OverallAmplitudeMask_ST;
float _OverallAmplitudeMaskOpacity;

int _ParticleSystem;
int _LifetimeFalloff;
float _LifetimeMinFalloff;
float _LifetimeMaxFalloff;
int _LifetimeFalloffCurve;


int _EyeSelector;
int _PlatformSelector;

#endif
