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
		public static string particleSystemSettingsTitle = "Particle System Settings";
		public static string falloffSettingsTitle = "Falloff Settings";
		public static string wobbleSettingsTitle = "Wave Distortion";
		public static string blurSettingsTitle = "Blur";
		public static string distortionMapSettingsTitle = "Distortion Mapping";
		public static string screenShakeSettingsTitle = "Screen Shake";
		public static string overlaySettingsTitle = "Overlay";
		public static string screenColorAdjustmentsTitle = "Screen Color Adjustment";
		public static string screenTransformTitle = "Screen Transformations";
		public static string projectionRotationText = "Rotation";
		public static string stencilTitle = "Stencil Testing";
		public static string maskingTitle = "Masking";
		public static string miscSettingsTitle = "Misc";
		public static string renderQueueExportTitle = "Custom Render Queue Exporter";
		public static string customRenderQueueSliderText = "Custom Render Queue";
		public static string exportCustomRenderQueueButtonText = "Export shader with queue and replace in this material";
		public static string blendSettingsTitle = "Blending";
		
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
	// i'm sorry, this was the laziest way i could tack this on
	protected static int categoryExpansionFlagsCancerfree;
	private static bool showRandomizerOptions = false;
	private static HashSet<String> propertiesWithRandomization = new HashSet<String>();
	
	protected int customRenderQueue;
	protected bool initialized;
	protected bool cancerfree;
	
	private bool randomizingCurrentPass;
	private System.Random rng;
	
	private void SetExpansionFlags(int flags) {
		if (cancerfree) {
			categoryExpansionFlagsCancerfree = flags;
		} else {
			categoryExpansionFlags = flags;
		}
	}
	
	private int GetExpansionFlags() {
		int flags;
		if (cancerfree) {
			flags = categoryExpansionFlagsCancerfree;
		} else {
			flags = categoryExpansionFlags;
		}
		return flags;
	}
	
	public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props) {
		if (!initialized) {
			customRenderQueue = (materialEditor.target as Material).shader.renderQueue;
			rng = new System.Random();
			initialized = true;
		}
		cancerfree = (materialEditor.target as Material).shader.name.Contains("Cancerfree");
		
		GUIStyle defaultStyle = new GUIStyle(EditorStyles.foldout);
		defaultStyle.fontStyle = FontStyle.Bold;
		defaultStyle.onNormal = EditorStyles.boldLabel.onNormal;
		defaultStyle.onFocused = EditorStyles.boldLabel.onFocused;
		
		List<CSCategory> categories = new List<CSCategory>();
		categories.Add(new CSCategory(Styles.falloffSettingsTitle, defaultStyle, me => {
			CSProperty falloffCurve = FindProperty("_FalloffCurve", props);
			CSProperty falloffDepth = FindProperty("_DepthFalloff", props);
			CSProperty falloffColor = FindProperty("_ColorFalloff", props);
			
			DisplayRegularProperty(me, falloffCurve);
			if (falloffCurve.prop.floatValue > .5) DisplayRegularProperty(me, FindProperty("_MinFalloff", props));
			DisplayRegularProperty(me, FindProperty("_MaxFalloff", props));
			DisplayRegularProperty(me, falloffDepth);
			if (falloffDepth.prop.floatValue > .5) {
				CSProperty falloffDepthCurve = FindProperty("_DepthFalloffCurve", props);
				
				DisplayRegularProperty(me, falloffDepthCurve);
				if (falloffDepthCurve.prop.floatValue > .5) DisplayRegularProperty(me, FindProperty("_DepthMinFalloff", props));
				DisplayRegularProperty(me, FindProperty("_DepthMaxFalloff", props));
			}
			DisplayRegularProperty(me, falloffColor);
			if (falloffColor.prop.floatValue > .5) {
				CSProperty falloffColorCurve = FindProperty("_ColorFalloffCurve", props);

				DisplayRegularProperty(me, FindProperty("_ColorChannelForFalloff", props));
				DisplayRegularProperty(me, falloffColorCurve);
				if (falloffColorCurve.prop.floatValue > .5) DisplayRegularProperty(me, FindProperty("_ColorMinFalloff", props));
				DisplayRegularProperty(me, FindProperty("_ColorMaxFalloff", props));
			}
		}));
		categories.Add(new CSCategory(Styles.particleSystemSettingsTitle, defaultStyle, me => {
			CSProperty falloffCurve = FindProperty("_LifetimeFalloffCurve", props);
			CSProperty falloff = FindProperty("_LifetimeFalloff", props);
			
			DisplayRegularProperty(me, FindProperty("_ParticleSystem", props));
			DisplayRegularProperty(me, falloff);
			if (falloff.prop.floatValue > .5) {
				DisplayRegularProperty(me, falloffCurve);
				if (falloffCurve.prop.floatValue > .5) DisplayRegularProperty(me, FindProperty("_LifetimeMinFalloff", props));
				DisplayRegularProperty(me, FindProperty("_LifetimeMaxFalloff", props));
			}
		}));
		if (!cancerfree) categories.Add(new CSCategory(Styles.screenShakeSettingsTitle, defaultStyle, me => {
			DisplayFloatWithSliderMode(me, FindProperty("_XShake", props));
			DisplayFloatWithSliderMode(me, FindProperty("_YShake", props));
			DisplayFloatWithSliderMode(me, FindProperty("_XShakeSpeed", props));
			DisplayFloatWithSliderMode(me, FindProperty("_YShakeSpeed", props));
			DisplayFloatWithSliderMode(me, FindProperty("_ShakeAmplitude", props));
		}));
		if (!cancerfree) categories.Add(new CSCategory(Styles.wobbleSettingsTitle, defaultStyle, me => {
			DisplayFloatRangeProperty(me, FindProperty("_XWobbleAmount", props));
			DisplayFloatRangeProperty(me, FindProperty("_YWobbleAmount", props));
			DisplayFloatRangeProperty(me, FindProperty("_XWobbleTiling", props));
			DisplayFloatRangeProperty(me, FindProperty("_YWobbleTiling", props));
			DisplayFloatWithSliderMode(me, FindProperty("_XWobbleSpeed", props));
			DisplayFloatWithSliderMode(me, FindProperty("_YWobbleSpeed", props));
		}));
		if (!cancerfree) categories.Add(new CSCategory(Styles.blurSettingsTitle, defaultStyle, me => {
			DisplayFloatWithSliderMode(me, FindProperty("_BlurRadius", props));
			DisplayIntSlider(me, FindProperty("_BlurSampling", props), 1, 5);
			DisplayRegularProperty(me, FindProperty("_AnimatedSampling", props));
		}));
		if (!cancerfree) categories.Add(new CSCategory(Styles.distortionMapSettingsTitle, defaultStyle, me => {
			CSProperty distortionType = FindProperty("_DistortionType", props);
			CSProperty distortionMapRotation = FindProperty("_DistortionMapRotation", props);
			CSProperty distortionAmplitude = FindProperty("_DistortionAmplitude", props);
			CSProperty distortionRotation = FindProperty("_DistortionRotation", props);
			CSProperty distortFlipbook = FindProperty("_DistortFlipbook", props);
			
			DisplayRegularProperty(me, distortionType);
			DisplayRegularProperty(me, FindProperty("_DistortionTarget", props));
			
			switch ((int) distortionType.prop.floatValue) {
				case 0:
					DisplayRegularProperty(me, FindProperty("_BumpMap", props));
					DisplayFloatWithSliderMode(me, distortionMapRotation);
					DisplayFloatWithSliderMode(me, distortionAmplitude);
					DisplayFloatWithSliderMode(me, distortionRotation);
					DisplayFloatWithSliderMode(me, FindProperty("_BumpMapScrollSpeedX", props));
					DisplayFloatWithSliderMode(me, FindProperty("_BumpMapScrollSpeedY", props));
					break;
				case 1:
					DisplayRegularProperty(me, FindProperty("_MeltMap", props));
					DisplayFloatWithSliderMode(me, distortionMapRotation);
					DisplayFloatWithSliderMode(me, distortionAmplitude);
					DisplayFloatWithSliderMode(me, distortionRotation);
					DisplayFloatWithSliderMode(me, FindProperty("_MeltController", props));
					DisplayFloatWithSliderMode(me, FindProperty("_MeltActivationScale", props));
					break;
			}
			
			DisplayRegularProperty(me, distortFlipbook);
			
			if (distortFlipbook.prop.floatValue != 0) {
				DisplayIntField(me, FindProperty("_DistortFlipbookTotalFrames", props));
				DisplayIntField(me, FindProperty("_DistortFlipbookStartFrame", props));
				DisplayIntField(me, FindProperty("_DistortFlipbookRows", props));
				DisplayIntField(me, FindProperty("_DistortFlipbookColumns", props));
				DisplayFloatProperty(me, FindProperty("_DistortFlipbookFPS", props));
			}
				
		}));
		categories.Add(new CSCategory(Styles.overlaySettingsTitle, defaultStyle, me => {
			CSProperty overlayImageType = FindProperty("_OverlayImageType", props);
			CSProperty overlayImage = FindProperty("_MainTex", props);
			CSProperty overlayRotation = FindProperty("_MainTexRotation", props);
			CSProperty overlayPixelate = FindProperty("_PixelatedSampling", props);
			CSProperty overlayScrollSpeedX = FindProperty("_MainTexScrollSpeedX", props);
			CSProperty overlayScrollSpeedY = FindProperty("_MainTexScrollSpeedY", props);
			CSProperty overlayBoundary = FindProperty("_OverlayBoundaryHandling", props);
			CSProperty overlayColor = FindProperty("_OverlayColor", props);
			
			if (!cancerfree) BlendModePopup(me, FindProperty("_BlendMode", props));
			
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
					DisplayIntField(me, FindProperty("_FlipbookTotalFrames", props));
					DisplayIntField(me, FindProperty("_FlipbookStartFrame", props));
					DisplayIntField(me, FindProperty("_FlipbookRows", props));
					DisplayIntField(me, FindProperty("_FlipbookColumns", props));
					DisplayFloatProperty(me, FindProperty("_FlipbookFPS", props));
					break;
				case 2:
					DisplayRegularProperty(me, FindProperty("_OverlayCubemap", props));
					DisplayColorProperty(me, overlayColor);
					DisplayVec3WithSliderMode(
						me,
						"Rotation",
						FindProperty("_OverlayCubemapRotationX", props),
						FindProperty("_OverlayCubemapRotationY", props),
						FindProperty("_OverlayCubemapRotationZ", props)
					);
					DisplayVec3WithSliderMode(
						me,
						"Rotation Speed",
						FindProperty("_OverlayCubemapSpeedX", props),
						FindProperty("_OverlayCubemapSpeedY", props),
						FindProperty("_OverlayCubemapSpeedZ", props)
					);
					break;
			}
			
			DisplayFloatRangeProperty(me, FindProperty("_BlendAmount", props));
		}));
		if (cancerfree) categories.Add(new CSCategory(Styles.blendSettingsTitle, defaultStyle, me => {
			DisplayRegularProperty(me, FindProperty("_BlendOp", props));
			DisplayRegularProperty(me, FindProperty("_BlendSource", props));
			DisplayRegularProperty(me, FindProperty("_BlendDestination", props));
		}));
		if (!cancerfree) categories.Add(new CSCategory(Styles.screenColorAdjustmentsTitle, defaultStyle, me => {
			CSProperty colorBurningToggle = FindProperty("_Burn", props);
			
			DisplayVec3WithSliderMode(
				me,
				"HSV Add",
				FindProperty("_HueAdd", props),
				FindProperty("_SaturationAdd", props),
				FindProperty("_ValueAdd", props)
			);
			DisplayVec3WithSliderMode(
				me,
				"HSV Multiply",
				FindProperty("_HueMultiply", props),
				FindProperty("_SaturationMultiply", props),
				FindProperty("_ValueMultiply", props)
			);
			
			DisplayFloatRangeProperty(me, FindProperty("_InversionAmount", props));
			DisplayColorProperty(me, FindProperty("_Color", props));
			
			BlendModePopup(me, FindProperty("_ScreenColorBlendMode", props));
			
			DisplayRegularProperty(me, colorBurningToggle);
			if (colorBurningToggle.prop.floatValue == 1) {
				DisplayFloatRangeProperty(me, FindProperty("_BurnLow", props));
				DisplayFloatRangeProperty(me, FindProperty("_BurnHigh", props));
			}
		}));
		if (!cancerfree) categories.Add(new CSCategory(Styles.screenTransformTitle, defaultStyle, me => {
			DisplayRegularProperty(me, FindProperty("_ScreenBoundaryHandling", props));
			DisplayRegularProperty(me, FindProperty("_ScreenReprojection", props));
			DisplayFloatWithSliderMode(me, FindProperty("_Zoom", props));
			DisplayRegularProperty(me, FindProperty("_Pixelation", props));
			
			CSProperty screenXOffsetR = FindProperty("_ScreenXOffsetR", props);
			CSProperty screenXOffsetG = FindProperty("_ScreenXOffsetG", props);
			CSProperty screenXOffsetB = FindProperty("_ScreenXOffsetB", props);
			CSProperty screenXOffsetA = FindProperty("_ScreenXOffsetA", props);
			CSProperty screenYOffsetR = FindProperty("_ScreenYOffsetR", props);
			CSProperty screenYOffsetG = FindProperty("_ScreenYOffsetG", props);
			CSProperty screenYOffsetB = FindProperty("_ScreenYOffsetB", props);
			CSProperty screenYOffsetA = FindProperty("_ScreenYOffsetA", props);
			CSProperty screenXMultiplierR = FindProperty("_ScreenXMultiplierR", props);
			CSProperty screenXMultiplierG = FindProperty("_ScreenXMultiplierG", props);
			CSProperty screenXMultiplierB = FindProperty("_ScreenXMultiplierB", props);
			CSProperty screenXMultiplierA = FindProperty("_ScreenXMultiplierA", props);
			CSProperty screenYMultiplierR = FindProperty("_ScreenYMultiplierR", props);
			CSProperty screenYMultiplierG = FindProperty("_ScreenYMultiplierG", props);
			CSProperty screenYMultiplierB = FindProperty("_ScreenYMultiplierB", props);
			CSProperty screenYMultiplierA = FindProperty("_ScreenYMultiplierA", props);
			
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
				DisplayVec4Field(me, "Screen X Offset (RGB)", screenXOffsetR, screenXOffsetG, screenXOffsetB, screenXOffsetA);
				DisplayVec4Field(me, "Screen Y Offset (RGB)", screenYOffsetR, screenYOffsetG, screenYOffsetB, screenYOffsetA);
				DisplayVec4Field(me, "Screen X Multiplier (RGB)", screenXMultiplierR, screenXMultiplierG, screenXMultiplierB, screenXMultiplierA);
				DisplayVec4Field(me, "Screen Y Multiplier (RGB)", screenYMultiplierR, screenYMultiplierG, screenYMultiplierB, screenYMultiplierA);
			}
			DisplayFloatRangeProperty(me, FindProperty("_ScreenRotationAngle", props));
		}));
		categories.Add(new CSCategory(Styles.targetObjectSettingsTitle, defaultStyle, me => {
			DisplayVec4Field(
				me,
				"Position",
				FindProperty("_ObjectPositionX", props),
				FindProperty("_ObjectPositionY", props),
				FindProperty("_ObjectPositionZ", props),
				FindProperty("_ObjectPositionA", props)
			);
			DisplayVec3Field(
				me,
				"Rotation",
				FindProperty("_ObjectRotationX", props),
				FindProperty("_ObjectRotationY", props),
				FindProperty("_ObjectRotationZ", props)
			);
			DisplayVec4Field(
				me,
				"Scale",
				FindProperty("_ObjectScaleX", props),
				FindProperty("_ObjectScaleY", props),
				FindProperty("_ObjectScaleZ", props),
				FindProperty("_ObjectScaleA", props)
			);
			DisplayRegularProperty(me, FindProperty("_Puffiness", props));
		}));
		categories.Add(new CSCategory(Styles.stencilTitle, defaultStyle, me => {
			DisplayIntSlider(me, FindProperty("_StencilRef", props), 0, 255);
			DisplayRegularProperty(me, FindProperty("_StencilComp", props));
			DisplayRegularProperty(me, FindProperty("_StencilPassOp", props));
			DisplayRegularProperty(me, FindProperty("_StencilFailOp", props));
			DisplayRegularProperty(me, FindProperty("_StencilZFailOp", props));
			DisplayIntSlider(me, FindProperty("_StencilReadMask", props), 0, 255);
			DisplayIntSlider(me, FindProperty("_StencilWriteMask", props), 0, 255);
		}));
		categories.Add(new CSCategory(Styles.maskingTitle, defaultStyle, me => {
			if (!cancerfree) {
				DisplayRegularProperty(me, FindProperty("_DistortionMask", props));
				DisplayFloatRangeProperty(me, FindProperty("_DistortionMaskOpacity", props));
			}
			
			DisplayRegularProperty(me, FindProperty("_OverlayMask", props));
			DisplayFloatRangeProperty(me, FindProperty("_OverlayMaskOpacity", props));
			
			DisplayRegularProperty(me, FindProperty("_OverallEffectMask", props));
			DisplayFloatRangeProperty(me, FindProperty("_OverallEffectMaskOpacity", props));
			BlendModePopup(me, FindProperty("_OverallEffectMaskBlendMode", props));

			EditorGUILayout.Space();
			
			DisplayRegularProperty(me, FindProperty("_OverallAmplitudeMask", props));
			DisplayFloatRangeProperty(me, FindProperty("_OverallAmplitudeMaskOpacity", props));
		}));
		categories.Add(new CSCategory(Styles.miscSettingsTitle, defaultStyle, me => {
			DisplayRegularProperty(me, FindProperty("_CullMode", props));
			DisplayRegularProperty(me, FindProperty("_ZTest", props));
			DisplayRegularProperty(me, FindProperty("_ZWrite", props));
			ShowColorMaskFlags(me, FindProperty("_ColorMask", props));
			DisplayRegularProperty(me, FindProperty("_MirrorMode", props));
			DisplayRegularProperty(me, FindProperty("_EyeSelector", props));
			DisplayRegularProperty(me, FindProperty("_PlatformSelector", props));
			CSProperty projectionType = FindProperty("_ProjectionType", props);
			DisplayRegularProperty(me, projectionType);
			if (projectionType.prop.floatValue != 2) {
				DisplayVec3WithSliderMode(
					me,
					Styles.projectionRotationText,
					FindProperty("_ProjectionRotX", props),
					FindProperty("_ProjectionRotY", props),
					FindProperty("_ProjectionRotZ", props)
				);
			}
		}));
		if (!cancerfree) categories.Add(new CSCategory(Styles.renderQueueExportTitle, defaultStyle, me => {
			Material material = me.target as Material;
			
			customRenderQueue = EditorGUILayout.IntSlider(Styles.customRenderQueueSliderText, customRenderQueue, 0, 5000);
			if (GUILayout.Button(Styles.exportCustomRenderQueueButtonText)) {
				int relativeQueue = customRenderQueue - ((int) UnityEngine.Rendering.RenderQueue.Transparent);
				string newQueueString = "Transparent" + (relativeQueue >= 0 ? "+" : "") + relativeQueue;
				string shaderName = "RedMage/Cancer" + (cancerfree ? "free" : "space");
				string newShaderPath = shaderName + " Queue " + customRenderQueue;
				
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
								} else if (line.Contains(shaderName)) {
									Regex rx = new Regex("\"[^\"]+\"", RegexOptions.Compiled);
									MatchCollection matches = rx.Matches(line);
									foreach (Match match in matches) {
										line = line.Replace(match.Value, "\"" + newShaderPath + "\"");
									}
								}
								if (!cancerfree) line = line.Replace("_Garb", "_Garb" + customRenderQueue);
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
		}));
		
		EditorGUIUtility.labelWidth = 0f;
		
		sliderMode = EditorGUILayout.ToggleLeft(Styles.sliderModeCheckboxText, sliderMode);
		showRandomizerOptions = EditorGUILayout.ToggleLeft(Styles.randomizerOptionsCheckboxText, showRandomizerOptions);
		if (showRandomizerOptions) {
			randomizingCurrentPass = GUILayout.Button("Randomize Values");
		}
		
		int oldflags = GetExpansionFlags();
		int newflags = 0;
		for (int i = 0; i < categories.Count; ++i) {
			bool expanded = EditorGUILayout.Foldout((oldflags & (1 << i)) != 0, categories[i].name, true, categories[i].style);
			newflags |= (expanded ? 1 : 0) << i;
			if (expanded) {
				EditorGUI.indentLevel++;
				categories[i].setupDelegate(materialEditor);
				EditorGUI.indentLevel--;
			}
		}
		SetExpansionFlags(newflags);
		
		
		if (!cancerfree) GUI.enabled = false;
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
