using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

public class CancerspaceInspector : ShaderGUI {
	
	public enum BlendMode {
		Multiply,
		Screen,
		Overlay,
		Add,
		Subtract,
		Difference,
		Divide,
		Darken,
		Lighten,
		Normal,
		ColorDodge,
		ColorBurn,
		HardLight,
		SoftLight,
		Exclusion
	}
	
	public static class Styles {
		public static string sliderModeCheckboxText = "Sliders for dummies";
		public static string randomizerOptionsCheckboxText = "Show Randomizer Controls";
		public static string shouldRandomizeCheckboxText = "Allow randomization";
		public static GUIContent overlayImageText = new GUIContent("Image Overlay", "The overlay image and color.");
		public static string targetObjectSettingsTitle = "Target Object Settings";
		public static string targetObjectPositionText = "Position";
		public static string targetObjectRotationText = "Rotation";
		public static string targetObjectScaleText = "Scale";
		public static string falloffSettingsTitle = "Falloff Settings";
		public static string wobbleSettingsTitle = "Wave Distortion";
		public static string blurSettingsTitle = "Blur";
		public static string distortionMapSettingsTitle = "Distortion Mapping";
		public static string screenShakeSettingsTitle = "Screen Shake";
		public static string overlaySettingsTitle = "Overlay";
		public static string cubeMapRotationText = "Rotation";
		public static string cubeMapSpeedText = "Rotation Speed";
		public static string screenColorAdjustmentsTitle = "Screen Color Adjustment";
		public static string hsvAddText = "HSV Add";
		public static string hsvMultiplyText = "HSV Multiply";
		public static string screenTransformTitle = "Screen Transformations";
		public static string screenXOffsetText = "Screen X Offset (RGB)";
		public static string screenYOffsetText = "Screen Y Offset (RGB)";
		public static string screenXMultiplierText = "Screen X Multiplier (RGB)";
		public static string screenYMultiplierText = "Screen Y Multiplier (RGB)";
		public static string screenXRotationOriginText = "Screen Rotation Origin X (RGB)";
		public static string screenYRotationOriginText = "Screen Rotation Origin Y (RGB)";
		public static string projectionRotationText = "Rotation";
		public static string screenRotationAngleText = "Screen Rotation Angle (RGB)";
		public static string stencilTitle = "Stencil Testing";
		public static string maskingTitle = "Masking";
		public static string miscSettingsTitle = "Misc";
		public static string renderQueueExportTitle = "Custom Render Queue Exporter";
		public static string customRenderQueueSliderText = "Custom Render Queue";
		public static string exportCustomRenderQueueButtonText = "Export shader with queue and replace in this material";
		
		public static readonly string[] blendNames = Enum.GetNames(typeof(BlendMode));
	}
	
	public delegate void CSCategorySetup(MaterialEditor me);
	public class CSCategory {
		public string name;
		public GUIStyle style;
		public CSCategorySetup setupDelegate;
		
		public CSCategory(string nname, GUIStyle sstyle, CSCategorySetup ssetupDelegate) {
			name = nname;
			style = sstyle;
			setupDelegate = ssetupDelegate;
		}
	}
	
	public class CSProperty {
		public MaterialProperty prop;
		
		public CSProperty(MaterialProperty property) {
			prop = property;
		}
		
		public static implicit operator CSProperty(MaterialProperty property) {
			return new CSProperty(property);
		}
	}
	
	protected static bool sliderMode = true;
	protected static int categoryExpansionFlags;
	private static bool showRandomizerOptions = false;
	private static HashSet<String> propertiesWithRandomization = new HashSet<String>();
	
	protected CSProperty cullMode;
	protected CSProperty zTest;
	protected CSProperty zWrite;
	protected CSProperty colorMask;
	
	protected CSProperty stencilRef;
	protected CSProperty stencilComp;
	protected CSProperty stencilPass;
	protected CSProperty stencilFail;
	protected CSProperty stencilZFail;
	protected CSProperty stencilReadMask;
	protected CSProperty stencilWriteMask;
	
	protected CSProperty puffiness;
	protected CSProperty objectPositionX, objectPositionY, objectPositionZ, objectPositionA;
	protected CSProperty objectRotationX, objectRotationY, objectRotationZ, objectRotationA;
	protected CSProperty objectScaleX, objectScaleY, objectScaleZ, objectScaleA;
	
	protected CSProperty falloffCurve;
	protected CSProperty falloffMinDistance;
	protected CSProperty falloffMaxDistance;
	protected CSProperty falloffDepth;
	protected CSProperty falloffDepthCurve;
	protected CSProperty falloffDepthMinDistance;
	protected CSProperty falloffDepthMaxDistance;
	
	protected CSProperty blurRadius;
	protected CSProperty blurSampling;
	protected CSProperty blurSamplingAnimated;
	
	protected CSProperty zoomAmount;
	protected CSProperty pixelationAmount;
	
	protected CSProperty wobbleXAmount;
	protected CSProperty wobbleYAmount;
	protected CSProperty wobbleXTiling;
	protected CSProperty wobbleYTiling;
	protected CSProperty wobbleXSpeed;
	protected CSProperty wobbleYSpeed;
	
	protected CSProperty shakeXAmount;
	protected CSProperty shakeYAmount;
	protected CSProperty shakeXSpeed;
	protected CSProperty shakeYSpeed;
	protected CSProperty shakeAmplitude;
	
	protected CSProperty overlayImageType;
	protected CSProperty overlayPixelate;
	protected CSProperty overlayBoundary;
	protected CSProperty overlayImage;
	protected CSProperty overlayRotation;
	protected CSProperty overlayScrollSpeedX;
	protected CSProperty overlayScrollSpeedY;
	protected CSProperty overlayFlipbookRows, overlayFlipbookCols;
	protected CSProperty overlayFlipbookStart, overlayFlipbookFrames, overlayFlipbookFPS;
	protected CSProperty overlayCubemap;
	protected CSProperty overlayCubemapRotX, overlayCubemapRotY, overlayCubemapRotZ;
	protected CSProperty overlayCubemapSpeedX, overlayCubemapSpeedY, overlayCubemapSpeedZ;
	protected CSProperty overlayColor;
	protected CSProperty overlayBlendAmount;
	protected CSProperty overlayBlendMode;

	protected CSProperty screenHueAdd, screenSaturationAdd, screenValueAdd;
	protected CSProperty screenHueMultiply, screenSaturationMultiply, screenValueMultiply;
	
	protected CSProperty screenInversion;
	protected CSProperty screenColor;
	protected CSProperty screenColorBlendMode;
	
	protected CSProperty colorBurningToggle;
	protected CSProperty colorBurningLow;
	protected CSProperty colorBurningHigh;
	
	protected CSProperty screenReprojection;
	protected CSProperty screenBoundaryHandling;
	protected CSProperty screenXOffsetR, screenXOffsetG, screenXOffsetB, screenXOffsetA;
	protected CSProperty screenYOffsetR, screenYOffsetG, screenYOffsetB, screenYOffsetA;
	protected CSProperty screenXMultiplierR, screenXMultiplierG, screenXMultiplierB, screenXMultiplierA;
	protected CSProperty screenYMultiplierR, screenYMultiplierG, screenYMultiplierB, screenYMultiplierA;
	protected CSProperty screenXRotationOrigin;
	protected CSProperty screenYRotationOrigin;
	protected CSProperty screenRotationAngle;
	
	protected CSProperty mirrorReflectionMode;
	
	protected CSProperty distortionType;
	protected CSProperty distortionTarget;
	protected CSProperty distortionMap;
	protected CSProperty meltMap;
	protected CSProperty distortionMapRotation;
	protected CSProperty meltTimeScale;
	protected CSProperty meltController;
	protected CSProperty distortionAmplitude;
	protected CSProperty distortionRotation;
	protected CSProperty distortionScrollSpeedX;
	protected CSProperty distortionScrollSpeedY;
	protected CSProperty distortFlipbook;
	protected CSProperty distortFlipbookRows, distortFlipbookCols;
	protected CSProperty distortFlipbookStart, distortFlipbookFrames, distortFlipbookFPS;
	
	protected CSProperty distortionMask;
	protected CSProperty distortionMaskOpacity;
	protected CSProperty overlayMask;
	protected CSProperty overlayMaskOpacity;
	protected CSProperty overallMask;
	protected CSProperty overallMaskOpacity;
	protected CSProperty overallMaskBlendMode;
	protected CSProperty overallAmpMask;
	protected CSProperty overallAmpMaskOpacity;
	
	protected CSProperty eyeSelector;
	protected CSProperty platformSelector;
	protected CSProperty projectionType;
	protected CSProperty projectionRotX, projectionRotY, projectionRotZ;
	
	protected int customRenderQueue;
	protected bool initialized;
	
	private bool randomizingCurrentPass;
	private System.Random rng;
	
	public void FindProperties(MaterialProperty[] props) {
		cullMode = FindProperty("_CullMode", props);
		zTest = FindProperty("_ZTest", props);
		zWrite = FindProperty("_ZWrite", props);
		colorMask = FindProperty("_ColorMask", props);
		
		stencilRef = FindProperty("_StencilRef", props);
		stencilComp = FindProperty("_StencilComp", props);
		stencilPass = FindProperty("_StencilPassOp", props);
		stencilFail = FindProperty("_StencilFailOp", props);
		stencilZFail = FindProperty("_StencilZFailOp", props);
		stencilReadMask = FindProperty("_StencilReadMask", props);
		stencilWriteMask = FindProperty("_StencilWriteMask", props);
		
		puffiness = FindProperty("_Puffiness", props);
		objectPositionX = FindProperty("_ObjectPositionX", props);
		objectPositionY = FindProperty("_ObjectPositionY", props);
		objectPositionZ = FindProperty("_ObjectPositionZ", props);
		objectPositionA = FindProperty("_ObjectPositionA", props);
		objectRotationX = FindProperty("_ObjectRotationX", props);
		objectRotationY = FindProperty("_ObjectRotationY", props);
		objectRotationZ = FindProperty("_ObjectRotationZ", props);
		objectScaleX = FindProperty("_ObjectScaleX", props);
		objectScaleY = FindProperty("_ObjectScaleY", props);
		objectScaleZ = FindProperty("_ObjectScaleZ", props);
		objectScaleA = FindProperty("_ObjectScaleA", props);
		
		falloffCurve = FindProperty("_FalloffCurve", props);
		falloffMinDistance = FindProperty("_MinFalloff", props);
		falloffMaxDistance = FindProperty("_MaxFalloff", props);
		falloffDepth = FindProperty("_DepthFalloff", props);
		falloffDepthCurve = FindProperty("_DepthFalloffCurve", props);
		falloffDepthMinDistance = FindProperty("_DepthMinFalloff", props);
		falloffDepthMaxDistance = FindProperty("_DepthMaxFalloff", props);
		
		blurRadius = FindProperty("_BlurRadius", props);
		blurSampling = FindProperty("_BlurSampling", props);
		blurSamplingAnimated = FindProperty("_AnimatedSampling", props);
		
		zoomAmount = FindProperty("_Zoom", props);
		pixelationAmount = FindProperty("_Pixelation", props);
		
		wobbleXAmount = FindProperty("_XWobbleAmount", props);
		wobbleYAmount = FindProperty("_YWobbleAmount", props);
		wobbleXTiling = FindProperty("_XWobbleTiling", props);
		wobbleYTiling = FindProperty("_YWobbleTiling", props);
		wobbleXSpeed = FindProperty("_XWobbleSpeed", props);
		wobbleYSpeed = FindProperty("_YWobbleSpeed", props);
		
		distortionType = FindProperty("_DistortionType", props);
		distortionTarget = FindProperty("_DistortionTarget", props);
		distortionMap = FindProperty("_BumpMap", props);
		distortionMapRotation = FindProperty("_DistortionMapRotation", props);
		distortionAmplitude = FindProperty("_DistortionAmplitude", props);
		distortionRotation = FindProperty("_DistortionRotation", props);
		distortionScrollSpeedX = FindProperty("_BumpMapScrollSpeedX", props);
		distortionScrollSpeedY = FindProperty("_BumpMapScrollSpeedY", props);
		meltMap = FindProperty("_MeltMap", props);
		meltController = FindProperty("_MeltController", props);
		meltTimeScale = FindProperty("_MeltActivationScale", props);
		distortionMask = FindProperty("_DistortionMask", props);
		distortFlipbook = FindProperty("_DistortFlipbook", props);
		distortFlipbookStart = FindProperty("_DistortFlipbookStartFrame", props);
		distortFlipbookFrames = FindProperty("_DistortFlipbookTotalFrames", props);
		distortFlipbookFPS = FindProperty("_DistortFlipbookFPS", props);
		distortFlipbookRows = FindProperty("_DistortFlipbookRows", props);
		distortFlipbookCols = FindProperty("_DistortFlipbookColumns", props);
		

		shakeXAmount = FindProperty("_XShake", props);
		shakeYAmount = FindProperty("_YShake", props);
		shakeXSpeed = FindProperty("_XShakeSpeed", props);
		shakeYSpeed = FindProperty("_YShakeSpeed", props);
		shakeAmplitude = FindProperty("_ShakeAmplitude", props);
		
		overlayImageType = FindProperty("_OverlayImageType", props);
		overlayImage = FindProperty("_MainTex", props);
		overlayRotation = FindProperty("_MainTexRotation", props);
		overlayPixelate = FindProperty("_PixelatedSampling", props);
		overlayScrollSpeedX = FindProperty("_MainTexScrollSpeedX", props);
		overlayScrollSpeedY = FindProperty("_MainTexScrollSpeedY", props);
		overlayBoundary = FindProperty("_OverlayBoundaryHandling", props);
		overlayFlipbookStart = FindProperty("_FlipbookStartFrame", props);
		overlayFlipbookFrames = FindProperty("_FlipbookTotalFrames", props);
		overlayFlipbookFPS = FindProperty("_FlipbookFPS", props);
		overlayFlipbookRows = FindProperty("_FlipbookRows", props);
		overlayFlipbookCols = FindProperty("_FlipbookColumns", props);
		overlayCubemap = FindProperty("_OverlayCubemap", props);
		overlayCubemapRotX = FindProperty("_OverlayCubemapRotationX", props);
		overlayCubemapRotY = FindProperty("_OverlayCubemapRotationY", props);
		overlayCubemapRotZ = FindProperty("_OverlayCubemapRotationZ", props);
		overlayCubemapSpeedX = FindProperty("_OverlayCubemapSpeedX", props);
		overlayCubemapSpeedY = FindProperty("_OverlayCubemapSpeedY", props);
		overlayCubemapSpeedZ = FindProperty("_OverlayCubemapSpeedZ", props);
		overlayColor = FindProperty("_OverlayColor", props);
		overlayBlendAmount = FindProperty("_BlendAmount", props);
		overlayBlendMode = FindProperty("_BlendMode", props);
		
		screenHueAdd = FindProperty("_HueAdd", props);
		screenSaturationAdd = FindProperty("_SaturationAdd", props);
		screenValueAdd = FindProperty("_ValueAdd", props);
		screenHueMultiply = FindProperty("_HueMultiply", props);
		screenSaturationMultiply = FindProperty("_SaturationMultiply", props);
		screenValueMultiply = FindProperty("_ValueMultiply", props);
		screenInversion = FindProperty("_InversionAmount", props);
		screenColor = FindProperty("_Color", props);
		screenColorBlendMode = FindProperty("_ScreenColorBlendMode", props);
		
		colorBurningToggle = FindProperty("_Burn", props);
		colorBurningLow = FindProperty("_BurnLow", props);
		colorBurningHigh = FindProperty("_BurnHigh", props);
		
		screenReprojection = FindProperty("_ScreenReprojection", props);
		screenBoundaryHandling = FindProperty("_ScreenBoundaryHandling", props);
		screenXOffsetR = FindProperty("_ScreenXOffsetR", props);
		screenXOffsetG = FindProperty("_ScreenXOffsetG", props);
		screenXOffsetB = FindProperty("_ScreenXOffsetB", props);
		screenXOffsetA = FindProperty("_ScreenXOffsetA", props);
		screenYOffsetR = FindProperty("_ScreenYOffsetR", props);
		screenYOffsetG = FindProperty("_ScreenYOffsetG", props);
		screenYOffsetB = FindProperty("_ScreenYOffsetB", props);
		screenYOffsetA = FindProperty("_ScreenYOffsetA", props);
		screenXMultiplierR = FindProperty("_ScreenXMultiplierR", props);
		screenXMultiplierG = FindProperty("_ScreenXMultiplierG", props);
		screenXMultiplierB = FindProperty("_ScreenXMultiplierB", props);
		screenXMultiplierA = FindProperty("_ScreenXMultiplierA", props);
		screenYMultiplierR = FindProperty("_ScreenYMultiplierR", props);
		screenYMultiplierG = FindProperty("_ScreenYMultiplierG", props);
		screenYMultiplierB = FindProperty("_ScreenYMultiplierB", props);
		screenYMultiplierA = FindProperty("_ScreenYMultiplierA", props);
		screenRotationAngle = FindProperty("_ScreenRotationAngle", props);
		
		distortionMask = FindProperty("_DistortionMask", props);
		distortionMaskOpacity = FindProperty("_DistortionMaskOpacity", props);
		overlayMask = FindProperty("_OverlayMask", props);
		overlayMaskOpacity = FindProperty("_OverlayMaskOpacity", props);
		overallMask = FindProperty("_OverallEffectMask", props);
		overallMaskOpacity = FindProperty("_OverallEffectMaskOpacity", props);
		overallMaskBlendMode = FindProperty("_OverallEffectMaskBlendMode", props);
		overallAmpMask = FindProperty("_OverallAmplitudeMask", props);
		overallAmpMaskOpacity = FindProperty("_OverallAmplitudeMaskOpacity", props);
		
		mirrorReflectionMode = FindProperty("_MirrorMode", props);
		eyeSelector = FindProperty("_EyeSelector", props);
		platformSelector = FindProperty("_PlatformSelector", props);
		projectionType = FindProperty("_ProjectionType", props);
		projectionRotX = FindProperty("_ProjectionRotX", props);
		projectionRotY = FindProperty("_ProjectionRotY", props);
		projectionRotZ = FindProperty("_ProjectionRotZ", props);
	}
	
	public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties) {
		FindProperties(properties);
		
		if (!initialized) {
			customRenderQueue = (materialEditor.target as Material).shader.renderQueue;
			rng = new System.Random();
			initialized = true;
		}
		
		GUIStyle defaultStyle = new GUIStyle(EditorStyles.foldout);
		defaultStyle.fontStyle = FontStyle.Bold;
		defaultStyle.onNormal = EditorStyles.boldLabel.onNormal;
		defaultStyle.onFocused = EditorStyles.boldLabel.onFocused;
		
		CSCategory[] categories = new CSCategory[] {
			new CSCategory(Styles.falloffSettingsTitle, defaultStyle, me => {
				DisplayRegularProperty(me, falloffCurve);
				if (falloffCurve.prop.floatValue > .5) DisplayRegularProperty(me, falloffMinDistance);
				DisplayRegularProperty(me, falloffMaxDistance);
				DisplayRegularProperty(me, falloffDepth);
				if (falloffDepth.prop.floatValue > .5) {
					DisplayRegularProperty(me, falloffDepthCurve);
					if (falloffDepthCurve.prop.floatValue > .5) DisplayRegularProperty(me, falloffDepthMinDistance);
					DisplayRegularProperty(me, falloffDepthMaxDistance);
				}
			}),
			
			new CSCategory(Styles.screenShakeSettingsTitle, defaultStyle, me => {
				DisplayFloatWithSliderMode(me, shakeXAmount);
				DisplayFloatWithSliderMode(me, shakeYAmount);
				DisplayFloatWithSliderMode(me, shakeXSpeed);
				DisplayFloatWithSliderMode(me, shakeYSpeed);
				DisplayFloatWithSliderMode(me, shakeAmplitude);
			}),
			
			new CSCategory(Styles.wobbleSettingsTitle, defaultStyle, me => {
				DisplayFloatRangeProperty(me, wobbleXAmount);
				DisplayFloatRangeProperty(me, wobbleYAmount);
				DisplayFloatRangeProperty(me, wobbleXTiling);
				DisplayFloatRangeProperty(me, wobbleYTiling);
				DisplayFloatWithSliderMode(me, wobbleXSpeed);
				DisplayFloatWithSliderMode(me, wobbleYSpeed);
			}),
			
			new CSCategory(Styles.blurSettingsTitle, defaultStyle, me => {
				DisplayFloatWithSliderMode(me, blurRadius);
				DisplayIntSlider(me, blurSampling, 1, 5);
				DisplayRegularProperty(me, blurSamplingAnimated);
			}),
			
			new CSCategory(Styles.distortionMapSettingsTitle, defaultStyle, me => {
				DisplayRegularProperty(me, distortionType);
				DisplayRegularProperty(me, distortionTarget);
				switch ((int) distortionType.prop.floatValue) {
					case 0:
						DisplayRegularProperty(me, distortionMap);
						DisplayFloatWithSliderMode(me, distortionMapRotation);
						DisplayFloatWithSliderMode(me, distortionAmplitude);
						DisplayFloatWithSliderMode(me, distortionRotation);
						DisplayFloatWithSliderMode(me, distortionScrollSpeedX);
						DisplayFloatWithSliderMode(me, distortionScrollSpeedY);
						break;
					case 1:
						DisplayRegularProperty(me, meltMap);
						DisplayFloatWithSliderMode(me, distortionMapRotation);
						DisplayFloatWithSliderMode(me, distortionAmplitude);
						DisplayFloatWithSliderMode(me, distortionRotation);
						DisplayFloatWithSliderMode(me, meltController);
						DisplayFloatWithSliderMode(me, meltTimeScale);
						break;
				}
				DisplayRegularProperty(me, distortFlipbook);
				if (distortFlipbook.prop.floatValue != 0) {
					DisplayIntField(me, distortFlipbookFrames);
					DisplayIntField(me, distortFlipbookStart);
					DisplayIntField(me, distortFlipbookRows);
					DisplayIntField(me, distortFlipbookCols);
					DisplayFloatProperty(me, distortFlipbookFPS);
				}
				
			}),
			
			new CSCategory(Styles.overlaySettingsTitle, defaultStyle, me => {
				BlendModePopup(me, overlayBlendMode);
				DisplayRegularProperty(me, overlayImageType);
				switch ((int) overlayImageType.prop.floatValue) {
					// TODO: replace these with proper enums so there's no magic numbers
					case 0:
						DisplayRegularProperty(me, overlayBoundary);
						DisplayRegularProperty(me, overlayPixelate);
						me.TexturePropertySingleLine(Styles.overlayImageText, overlayImage.prop, overlayColor.prop);
						me.TextureScaleOffsetProperty(overlayImage.prop);
						DisplayFloatWithSliderMode(me, overlayRotation);
						if (overlayBoundary.prop.floatValue != 0) {
							DisplayFloatWithSliderMode(me, overlayScrollSpeedX);
							DisplayFloatWithSliderMode(me, overlayScrollSpeedY);
						}
						break;
					case 1:
						DisplayRegularProperty(me, overlayBoundary);
						DisplayRegularProperty(me, overlayPixelate);
						me.TexturePropertySingleLine(Styles.overlayImageText, overlayImage.prop, overlayColor.prop);
						me.TextureScaleOffsetProperty(overlayImage.prop);
						DisplayFloatWithSliderMode(me, overlayRotation);
						if (overlayBoundary.prop.floatValue != 0) {
							DisplayFloatWithSliderMode(me, overlayScrollSpeedX);
							DisplayFloatWithSliderMode(me, overlayScrollSpeedY);
						}
						DisplayIntField(me, overlayFlipbookFrames);
						DisplayIntField(me, overlayFlipbookStart);
						DisplayIntField(me, overlayFlipbookRows);
						DisplayIntField(me, overlayFlipbookCols);
						DisplayFloatProperty(me, overlayFlipbookFPS);
						break;
					case 2:
						DisplayRegularProperty(me, overlayCubemap);
						DisplayColorProperty(me, overlayColor);
						DisplayVec3WithSliderMode(me, Styles.cubeMapRotationText, overlayCubemapRotX, overlayCubemapRotY, overlayCubemapRotZ);
						DisplayVec3WithSliderMode(me, Styles.cubeMapSpeedText, overlayCubemapSpeedX, overlayCubemapSpeedY, overlayCubemapSpeedZ);
						break;
				}
				DisplayFloatRangeProperty(me, overlayBlendAmount);
			}),
			
			new CSCategory(Styles.screenColorAdjustmentsTitle, defaultStyle, me => {
				DisplayVec3WithSliderMode(me, Styles.hsvAddText, screenHueAdd, screenSaturationAdd, screenValueAdd);
				DisplayVec3WithSliderMode(me, Styles.hsvMultiplyText, screenHueMultiply, screenSaturationMultiply, screenValueMultiply);
				DisplayFloatRangeProperty(me, screenInversion);
				DisplayColorProperty(me, screenColor);
				BlendModePopup(me, screenColorBlendMode);
				DisplayRegularProperty(me, colorBurningToggle);
				if (colorBurningToggle.prop.floatValue == 1) {
					DisplayFloatRangeProperty(me, colorBurningLow);
					DisplayFloatRangeProperty(me, colorBurningHigh);
				}
			}),
			
			new CSCategory(Styles.screenTransformTitle, defaultStyle, me => {
				DisplayRegularProperty(me, screenBoundaryHandling);
				DisplayRegularProperty(me, screenReprojection);
				DisplayFloatWithSliderMode(me, zoomAmount);
				DisplayRegularProperty(me, pixelationAmount);
				if (sliderMode) {
					DisplayFloatRangeProperty(me, screenXOffsetA);
					DisplayFloatRangeProperty(me, screenYOffsetA);
					DisplayFloatRangeProperty(me, screenXOffsetR);
					DisplayFloatRangeProperty(me, screenYOffsetR);
					DisplayFloatRangeProperty(me, screenXOffsetG);
					DisplayFloatRangeProperty(me, screenYOffsetG);
					DisplayFloatRangeProperty(me, screenXOffsetB);
					DisplayFloatRangeProperty(me, screenYOffsetB);
					DisplayFloatRangeProperty(me, screenXMultiplierA);
					DisplayFloatRangeProperty(me, screenYMultiplierA);
					DisplayFloatRangeProperty(me, screenXMultiplierR);
					DisplayFloatRangeProperty(me, screenYMultiplierR);
					DisplayFloatRangeProperty(me, screenXMultiplierG);
					DisplayFloatRangeProperty(me, screenYMultiplierG);
					DisplayFloatRangeProperty(me, screenXMultiplierB);
					DisplayFloatRangeProperty(me, screenYMultiplierB);
				} else {
					DisplayVec4Field(me, Styles.screenXOffsetText, screenXOffsetR, screenXOffsetG, screenXOffsetB, screenXOffsetA);
					DisplayVec4Field(me, Styles.screenYOffsetText, screenYOffsetR, screenYOffsetG, screenYOffsetB, screenYOffsetA);
					DisplayVec4Field(me, Styles.screenXMultiplierText, screenXMultiplierR, screenXMultiplierG, screenXMultiplierB, screenXMultiplierA);
					DisplayVec4Field(me, Styles.screenYMultiplierText, screenYMultiplierR, screenYMultiplierG, screenYMultiplierB, screenYMultiplierA);
				}
				DisplayFloatRangeProperty(me, screenRotationAngle);
			}),
			
			new CSCategory(Styles.targetObjectSettingsTitle, defaultStyle, me => {
				DisplayVec4Field(me, Styles.targetObjectPositionText, objectPositionX, objectPositionY, objectPositionZ, objectPositionA);
				DisplayVec3Field(me, Styles.targetObjectRotationText, objectRotationX, objectRotationY, objectRotationZ);
				DisplayVec4Field(me, Styles.targetObjectScaleText, objectScaleX, objectScaleY, objectScaleZ, objectScaleA);
				DisplayRegularProperty(me, puffiness);
			}),
			
			new CSCategory(Styles.stencilTitle, defaultStyle, me => {
				DisplayIntSlider(me, stencilRef, 0, 255);
				DisplayRegularProperty(me, stencilComp);
				DisplayRegularProperty(me, stencilPass);
				DisplayRegularProperty(me, stencilFail);
				DisplayRegularProperty(me, stencilZFail);
				DisplayIntSlider(me, stencilReadMask, 0, 255);
				DisplayIntSlider(me, stencilWriteMask, 0, 255);
			}),
			
			new CSCategory(Styles.maskingTitle, defaultStyle, me => {
				DisplayRegularProperty(me, distortionMask);
				DisplayFloatRangeProperty(me, distortionMaskOpacity);
				
				DisplayRegularProperty(me, overlayMask);
				DisplayFloatRangeProperty(me, overlayMaskOpacity);
				
				DisplayRegularProperty(me, overallMask);
				DisplayFloatRangeProperty(me, overallMaskOpacity);
				BlendModePopup(me, overallMaskBlendMode);

				EditorGUILayout.Space();
				
				DisplayRegularProperty(me, overallAmpMask);
				DisplayFloatRangeProperty(me, overallAmpMaskOpacity);
			}),
			
			new CSCategory(Styles.miscSettingsTitle, defaultStyle, me => {
				DisplayRegularProperty(me, cullMode);
				DisplayRegularProperty(me, zTest);
				DisplayRegularProperty(me, zWrite);
				ShowColorMaskFlags(me, colorMask);
				DisplayRegularProperty(me, mirrorReflectionMode);
				DisplayRegularProperty(me, eyeSelector);
				DisplayRegularProperty(me, platformSelector);
				DisplayRegularProperty(me, projectionType);
				if (projectionType.prop.floatValue != 2) {
					DisplayVec3WithSliderMode(me, Styles.projectionRotationText, projectionRotX, projectionRotY, projectionRotZ);
				}
			}),
			
			new CSCategory(Styles.renderQueueExportTitle, defaultStyle, me => {
				Material material = me.target as Material;
				
				customRenderQueue = EditorGUILayout.IntSlider(Styles.customRenderQueueSliderText, customRenderQueue, 0, 5000);
				if (GUILayout.Button(Styles.exportCustomRenderQueueButtonText)) {
					int relativeQueue = customRenderQueue - ((int) UnityEngine.Rendering.RenderQueue.Transparent);
					string newQueueString = "Transparent" + (relativeQueue >= 0 ? "+" : "") + relativeQueue;
					string newShaderPath = "RedMage/Cancerspace Queue " + customRenderQueue;
					
					string shaderPath = AssetDatabase.GetAssetPath(material.shader.GetInstanceID());
					string outputLocation = shaderPath.Substring(0, shaderPath.Replace("\\", "/").LastIndexOf('/') + 1) + "CancerspaceQueue" + customRenderQueue + ".shader";
					
					try {
						using (StreamWriter sw = new StreamWriter(outputLocation)) {
							using (StreamReader sr = new StreamReader(shaderPath)) {
								string line;
								while ((line = sr.ReadLine()) != null) {
									if (line.Contains("\"Transparent+")) {
										Regex rx = new Regex(@"Transparent[+-]\d+", RegexOptions.Compiled);
										MatchCollection matches = rx.Matches(line);
										foreach (Match match in matches) {
											line = line.Replace(match.Value, newQueueString);
										}
									} else if (line.Contains("RedMage/Cancerspace")) {
										Regex rx = new Regex("\"[^\"]+\"", RegexOptions.Compiled);
										MatchCollection matches = rx.Matches(line);
										foreach (Match match in matches) {
											line = line.Replace(match.Value, "\"" + newShaderPath + "\"");
										}
									}
									line = line.Replace("_Garb", "_Garb" + customRenderQueue);
									sw.Write(line);
									sw.WriteLine();
								}
							}
						}
					} catch (Exception e) {
						Debug.Log("AAAGAGHH WHAT? HOW? WHY??? WHAT ARE YOU DOING? Shader file could not be read / written.");
						Debug.Log(e.Message);
						return;
					}
					
					AssetDatabase.Refresh();
					
					material.shader = Shader.Find(newShaderPath);
					
					AssetDatabase.SaveAssets();
				}
			}),
		};
		
		EditorGUIUtility.labelWidth = 0f;
		
		sliderMode = EditorGUILayout.ToggleLeft(Styles.sliderModeCheckboxText, sliderMode);
		showRandomizerOptions = EditorGUILayout.ToggleLeft(Styles.randomizerOptionsCheckboxText, showRandomizerOptions);
		if (showRandomizerOptions) {
			randomizingCurrentPass = GUILayout.Button("Randomize Values");
		}
		
		int oldflags = categoryExpansionFlags;
		int newflags = 0;
		for (int i = 0; i < categories.Length; ++i) {
			bool expanded = EditorGUILayout.Foldout((oldflags & (1 << i)) != 0, categories[i].name, true, categories[i].style);
			newflags |= (expanded ? 1 : 0) << i;
			if (expanded) {
				EditorGUI.indentLevel++;
				categories[i].setupDelegate(materialEditor);
				EditorGUI.indentLevel--;
			}
		}
		categoryExpansionFlags = newflags;
		
		
		GUI.enabled = false;
		materialEditor.RenderQueueField();
		
		randomizingCurrentPass = false;
	}
	
	void BlendModePopup(MaterialEditor materialEditor, CSProperty prop) {
		EditorGUI.showMixedValue = prop.prop.hasMixedValue;
		var mode = (BlendMode) prop.prop.floatValue;
		EditorGUI.BeginChangeCheck();
		mode = (BlendMode) EditorGUILayout.Popup(prop.prop.displayName, (int) mode, Styles.blendNames);
		if (EditorGUI.EndChangeCheck()) {
			materialEditor.RegisterPropertyChangeUndo(prop.prop.displayName);
			prop.prop.floatValue = (float) mode;
		}
		EditorGUI.showMixedValue = false;
	}
	
	void DisplayRegularProperty(MaterialEditor me, CSProperty prop) {
		me.ShaderProperty(prop.prop, prop.prop.displayName);
	}
	
	void DisplayColorProperty(MaterialEditor me, CSProperty prop, bool randomizable = true) {
		bool randomizationEnabled = propertiesWithRandomization.Contains(prop.prop.name);
		if (randomizationEnabled && randomizingCurrentPass) {
			// TODO: make ranges more configurable
			prop.prop.colorValue = new Color((float) rng.NextDouble(), (float) rng.NextDouble(), (float) rng.NextDouble(), (float) rng.NextDouble());
		}
		me.ColorProperty(prop.prop, prop.prop.displayName);
		if (randomizable && showRandomizerOptions) {
			bool newState = EditorGUILayout.ToggleLeft(Styles.shouldRandomizeCheckboxText, randomizationEnabled);
			if (newState != randomizationEnabled) {
				if (newState) propertiesWithRandomization.Add(prop.prop.name);
				else propertiesWithRandomization.Remove(prop.prop.name);
			}
		}
	}
	
	void DisplayFloatRangeProperty(MaterialEditor me, CSProperty prop, bool randomizable = true) {
		bool randomizationEnabled = propertiesWithRandomization.Contains(prop.prop.name);
		if (randomizationEnabled && randomizingCurrentPass) {
			// TODO: make ranges more configurable
			prop.prop.floatValue = (float) (rng.NextDouble() * (prop.prop.rangeLimits.y - prop.prop.rangeLimits.x) + prop.prop.rangeLimits.x);
		}
		me.RangeProperty(prop.prop, prop.prop.displayName);
		if (randomizable && showRandomizerOptions) {
			bool newState = EditorGUILayout.ToggleLeft(Styles.shouldRandomizeCheckboxText, randomizationEnabled);
			if (newState != randomizationEnabled) {
				if (newState) propertiesWithRandomization.Add(prop.prop.name);
				else propertiesWithRandomization.Remove(prop.prop.name);
			}
		}
	}
	
	void DisplayFloatProperty(MaterialEditor me, CSProperty prop, bool randomizable = true) {
		bool randomizationEnabled = propertiesWithRandomization.Contains(prop.prop.name);
		if (randomizationEnabled && randomizingCurrentPass) {
			// TODO: make ranges more configurable
			prop.prop.floatValue = (float) (rng.NextDouble() * 100);
		}
		me.FloatProperty(prop.prop, prop.prop.displayName);
		if (randomizable && showRandomizerOptions) {
			bool newState = EditorGUILayout.ToggleLeft(Styles.shouldRandomizeCheckboxText, randomizationEnabled);
			if (newState != randomizationEnabled) {
				if (newState) propertiesWithRandomization.Add(prop.prop.name);
				else propertiesWithRandomization.Remove(prop.prop.name);
			}
		}
	}
	
	void DisplayFloatWithSliderMode(MaterialEditor me, CSProperty prop, bool randomizable = true) {
		if (sliderMode) DisplayFloatRangeProperty(me, prop, randomizable);
		else DisplayFloatProperty(me, prop, randomizable);
	}
	
	void DisplayVec3WithSliderMode(MaterialEditor me, string displayName, CSProperty xProp, CSProperty yProp, CSProperty zProp) {
		if (sliderMode) {
			DisplayFloatRangeProperty(me, xProp.prop);
			DisplayFloatRangeProperty(me, yProp.prop);
			DisplayFloatRangeProperty(me, zProp.prop);
		} else {
			DisplayVec3Field(me, displayName, xProp.prop, yProp.prop, zProp.prop);
		}
	}
	
	void DisplayVec3Field(MaterialEditor materialEditor, string displayName, CSProperty _xProp, CSProperty _yProp, CSProperty _zProp) {
		MaterialProperty xProp = _xProp.prop;
		MaterialProperty yProp = _yProp.prop;
		MaterialProperty zProp = _zProp.prop;
		materialEditor.BeginAnimatedCheck(xProp);
		materialEditor.BeginAnimatedCheck(yProp);
		materialEditor.BeginAnimatedCheck(zProp);
		EditorGUI.BeginChangeCheck();
		EditorGUI.showMixedValue = xProp.hasMixedValue || yProp.hasMixedValue || zProp.hasMixedValue;
		
		var oldLabelWidth = EditorGUIUtility.labelWidth;
		EditorGUIUtility.labelWidth = 0f;
		
		Vector3 v = EditorGUILayout.Vector3Field(displayName, new Vector3(xProp.floatValue, yProp.floatValue, zProp.floatValue));
		
		EditorGUIUtility.labelWidth = oldLabelWidth;
		
		EditorGUI.showMixedValue = false;
		
		if (EditorGUI.EndChangeCheck()) {
			xProp.floatValue = v.x;
			yProp.floatValue = v.y;
			zProp.floatValue = v.z;
		}
		
		materialEditor.EndAnimatedCheck();
		materialEditor.EndAnimatedCheck();
		materialEditor.EndAnimatedCheck();
	}
	
	void DisplayVec4Field(MaterialEditor materialEditor, string displayName, CSProperty _xProp, CSProperty _yProp, CSProperty _zProp, CSProperty _wProp) {
		MaterialProperty xProp = _xProp.prop;
		MaterialProperty yProp = _yProp.prop;
		MaterialProperty zProp = _zProp.prop;
		MaterialProperty wProp = _wProp.prop;
		materialEditor.BeginAnimatedCheck(xProp);
		materialEditor.BeginAnimatedCheck(yProp);
		materialEditor.BeginAnimatedCheck(zProp);
		materialEditor.BeginAnimatedCheck(wProp);
		EditorGUI.BeginChangeCheck();
		EditorGUI.showMixedValue = xProp.hasMixedValue || yProp.hasMixedValue || zProp.hasMixedValue || wProp.hasMixedValue;
		
		var oldLabelWidth = EditorGUIUtility.labelWidth;
		EditorGUIUtility.labelWidth = 0f;
		
		Vector4 v = EditorGUILayout.Vector4Field(displayName, new Vector4(xProp.floatValue, yProp.floatValue, zProp.floatValue, wProp.floatValue));
		
		EditorGUIUtility.labelWidth = oldLabelWidth;
		
		EditorGUI.showMixedValue = false;
		
		if (EditorGUI.EndChangeCheck()) {
			xProp.floatValue = v.x;
			yProp.floatValue = v.y;
			zProp.floatValue = v.z;
			wProp.floatValue = v.w;
		}
		
		materialEditor.EndAnimatedCheck();
		materialEditor.EndAnimatedCheck();
		materialEditor.EndAnimatedCheck();
		materialEditor.EndAnimatedCheck();
	}
	
	void DisplayIntField(MaterialEditor materialEditor, CSProperty property) {
		EditorGUI.showMixedValue = property.prop.hasMixedValue;
		int v = (int) property.prop.floatValue;
		EditorGUI.BeginChangeCheck();
		v = EditorGUILayout.IntField(property.prop.displayName, v);
		if (EditorGUI.EndChangeCheck()) {
			materialEditor.RegisterPropertyChangeUndo(property.prop.displayName);
			property.prop.floatValue = (float) v;
		}
		EditorGUI.showMixedValue = false;
	}
	
	void DisplayIntSlider(MaterialEditor materialEditor, CSProperty property, int min, int max) {
		EditorGUI.showMixedValue = property.prop.hasMixedValue;
		int v = (int) property.prop.floatValue;
		EditorGUI.BeginChangeCheck();
		v = EditorGUILayout.IntSlider(property.prop.displayName, v, min, max);
		if (EditorGUI.EndChangeCheck()) {
			materialEditor.RegisterPropertyChangeUndo(property.prop.displayName);
			property.prop.floatValue = (float) v;
		}
		EditorGUI.showMixedValue = false;
	}
	
	void ShowColorMaskFlags(MaterialEditor materialEditor, CSProperty property) {
		EditorGUI.showMixedValue = property.prop.hasMixedValue;
		ColorWriteMask v = (ColorWriteMask) ((int) property.prop.floatValue);
		EditorGUI.BeginChangeCheck();
		v = (ColorWriteMask) EditorGUILayout.EnumFlagsField(property.prop.displayName, v);
		if (EditorGUI.EndChangeCheck()) {
			materialEditor.RegisterPropertyChangeUndo(property.prop.displayName);
			int x = (int) v;
			if (x == -1) x = 15;
			property.prop.floatValue = (float) x;
		}
		EditorGUI.showMixedValue = false;
	}
}
