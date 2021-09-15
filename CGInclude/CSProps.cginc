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
#ifdef CANCERFREE
#define _Color ((float4)1)
#define _ScreenColorBlendMode (0)
#else
float4 _Color;
int _ScreenColorBlendMode;
#endif

#ifdef CANCERFREE
#define _XShake (0)
#define _YShake (0)
#define _XShakeSpeed (0)
#define _YShakeSpeed (0)
#define _ShakeAmplitude (0)
#else
float _XShake, _YShake;
float _XShakeSpeed, _YShakeSpeed;
float _ShakeAmplitude;
#endif

#ifdef CANCERFREE
#define _XWobbleAmount (0)
#define _YWobbleAmount (0)
#define _XWobbleTiling (0)
#define _YWobbleTiling (0)
#define _XWobbleSpeed (0)
#define _YWobbleSpeed (0)
#else
float _XWobbleAmount, _YWobbleAmount, _XWobbleTiling, _YWobbleTiling, _XWobbleSpeed, _YWobbleSpeed;
#endif

#ifdef CANCERFREE
#define _BlendMode (0)
#else
int _BlendMode;
#endif
float _BlendAmount;

#ifdef CANCERFREE
#define _InversionAmount (0)
#else
float _InversionAmount;
#endif

#ifdef CANCERFREE
#define _Pixelation (0)
#else
float _Pixelation;
#endif

float _HueAdd, _SaturationAdd, _ValueAdd;
float _HueMultiply, _SaturationMultiply, _ValueMultiply;

#ifdef CANCERFREE
#define _Zoom (0)
#else
float _Zoom;
#endif

#ifdef CANCERFREE
#define _Burn (0)
#define _BurnLow (0)
#define _BurnHigh (0)
#else
int _Burn;
float _BurnLow, _BurnHigh;
#endif

float _Puffiness;

float _ObjectPositionX, _ObjectPositionY, _ObjectPositionZ, _ObjectPositionA;
float _ObjectRotationX, _ObjectRotationY, _ObjectRotationZ;
float _ObjectScaleX, _ObjectScaleY, _ObjectScaleZ, _ObjectScaleA;

int _MirrorMode;

#ifdef CANCERFREE
#define _ScreenReprojection (0)
#define _ScreenXOffsetR (0)
#define _ScreenXOffsetG (0)
#define _ScreenXOffsetB (0)
#define _ScreenXOffsetA (0)
#define _ScreenYOffsetR (0)
#define _ScreenYOffsetG (0)
#define _ScreenYOffsetB (0)
#define _ScreenYOffsetA (0)
#define _ScreenXMultiplierR (0)
#define _ScreenXMultiplierG (0)
#define _ScreenXMultiplierB (0)
#define _ScreenXMultiplierA (0)
#define _ScreenYMultiplierR (0)
#define _ScreenYMultiplierG (0)
#define _ScreenYMultiplierB (0)
#define _ScreenYMultiplierA (0)
#define _ScreenRotationAngle (0)
#define _ScreenBoundaryHandling (0)
#else
int _ScreenReprojection;
float _ScreenXOffsetR, _ScreenXOffsetG, _ScreenXOffsetB, _ScreenXOffsetA;
float _ScreenYOffsetR, _ScreenYOffsetG, _ScreenYOffsetB, _ScreenYOffsetA;
float _ScreenXMultiplierR, _ScreenXMultiplierG, _ScreenXMultiplierB, _ScreenXMultiplierA;
float _ScreenYMultiplierR, _ScreenYMultiplierG, _ScreenYMultiplierB, _ScreenYMultiplierA;

float _ScreenRotationAngle;

int _ScreenBoundaryHandling;
#endif

// blurring method is based on https://www.shadertoy.com/view/XsVBDR
#ifdef CANCERFREE
#define _BlurSampling (0)
#define _AnimatedSampling (0)
#define _BlurRadius (0)
#else
int _BlurSampling;
float _AnimatedSampling;
float _BlurRadius;
#endif

#ifdef CANCERFREE
#define _DistortionType (0)
#define _DistortionTarget (0)
#define _BumpMap_TexelSize ((float4)0)
#define _BumpMap_ST ((float4)0)
#define _DistortionMapRotation (0)
#define _DistortionAmplitude (0)
#define _DistortionRotation (0)
#define _BumpMapScrollSpeedX (0)
#define _BumpMapScrollSpeedY (0)
#define _MeltMap_TexelSize ((float4)0)
#define _MeltMap_ST ((float4)0)
#define _MeltController (0)
#define _MeltActivationScale (0)
#else
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
#endif

#ifdef CANCERFREE
#define _DistortionMask_ST ((float4)0)
#define _DistortionMaskOpacity (0)
#else
sampler2D _DistortionMask;
float4 _DistortionMask_ST;
float _DistortionMaskOpacity;
#endif
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


float _ColorMinFalloff;
float _ColorMaxFalloff;
float _ColorFalloffCurve;
int _ColorFalloff;
uint _ColorChannelForFalloff;

#endif
