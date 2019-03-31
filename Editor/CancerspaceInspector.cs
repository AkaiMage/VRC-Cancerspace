using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using System;
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
		Lerp
	}
	
	public static class Styles {
		public static string sliderModeCheckboxText = "Sliders for dummies";
		public static GUIContent overlayImageText = new GUIContent("Image Overlay", "The overlay image and color.");
		public static string targetObjectSettingsTitle = "Target Object Settings";
		public static string falloffSettingsTitle = "Falloff Settings";
		public static string wobbleSettingsTitle = "Wave Distortion";
		public static string blurSettingsTitle = "Blur";
		public static string distortionMapSettingsTitle = "Distortion Mapping";
		public static string screenShakeSettingsTitle = "Screen Shake";
		public static string overlaySettingsTitle = "Overlay";
		public static string screenColorAdjustmentsTitle = "Screen Color Adjustment";
		public static string hsvAddText = "HSV Add";
		public static string hsvMultiplyText = "HSV Multiply";
		public static string screenTransformTitle = "Screen Transformations";
		public static string screenXOffsetText = "Screen X Offset (RGB)";
		public static string screenYOffsetText = "Screen Y Offset (RGB)";
		public static string screenXMultiplierText = "Screen X Multiplier (RGB)";
		public static string screenYMultiplierText = "Screen Y Multiplier (RGB)";
		public static string stencilTitle = "Stencil Testing";
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
	
	protected static bool sliderMode = true;
	protected static int categoryExpansionFlags;
	
	protected MaterialProperty cullMode;
	protected MaterialProperty zTest;
	protected MaterialProperty zWrite;
	protected MaterialProperty colorMask;
	
	protected MaterialProperty stencilRef;
	protected MaterialProperty stencilComp;
	protected MaterialProperty stencilPass;
	protected MaterialProperty stencilFail;
	protected MaterialProperty stencilZFail;
	protected MaterialProperty stencilReadMask;
	protected MaterialProperty stencilWriteMask;
	
	protected MaterialProperty puffiness;
	
	protected MaterialProperty falloffMaxDistance;
	
	protected MaterialProperty blurRadius;
	protected MaterialProperty blurSampling;
	protected MaterialProperty blurSamplingAnimated;
	
	protected MaterialProperty zoomAmount;
	protected MaterialProperty pixelationAmount;
	
	protected MaterialProperty wobbleXAmount;
	protected MaterialProperty wobbleYAmount;
	protected MaterialProperty wobbleXTiling;
	protected MaterialProperty wobbleYTiling;
	protected MaterialProperty wobbleXSpeed;
	protected MaterialProperty wobbleYSpeed;
	
	protected MaterialProperty shakeXAmount;
	protected MaterialProperty shakeYAmount;
	protected MaterialProperty shakeXSpeed;
	protected MaterialProperty shakeYSpeed;
	protected MaterialProperty shakeAmplitude;
	
	protected MaterialProperty overlayImage;
	protected MaterialProperty overlayColor;
	protected MaterialProperty overlayBlendAmount;
	protected MaterialProperty overlayBlendMode;

	protected MaterialProperty screenHueAdd, screenSaturationAdd, screenValueAdd;
	protected MaterialProperty screenHueMultiply, screenSaturationMultiply, screenValueMultiply;
	
	protected MaterialProperty screenInversion;
	protected MaterialProperty screenColor;
	
	protected MaterialProperty colorBurningToggle;
	protected MaterialProperty colorBurningLow;
	protected MaterialProperty colorBurningHigh;
	
	protected MaterialProperty screenBoundaryHandling;
	protected MaterialProperty screenXOffsetR, screenXOffsetG, screenXOffsetB, screenXOffsetA;
	protected MaterialProperty screenYOffsetR, screenYOffsetG, screenYOffsetB, screenYOffsetA;
	protected MaterialProperty screenXMultiplierR, screenXMultiplierG, screenXMultiplierB, screenXMultiplierA;
	protected MaterialProperty screenYMultiplierR, screenYMultiplierG, screenYMultiplierB, screenYMultiplierA;
	protected MaterialProperty screenXRotationOrigin;
	protected MaterialProperty screenYRotationOrigin;
	protected MaterialProperty screenRotationAngle;
	
	protected MaterialProperty mirrorReflectionMode;
	
	protected MaterialProperty distortionMap;
	protected MaterialProperty distortionAmplitude;
	protected MaterialProperty distortionScrollSpeedX;
	protected MaterialProperty distortionScrollSpeedY;
	
	protected int customRenderQueue;
	protected bool initialized;
	
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
		
		falloffMaxDistance = FindProperty("_MaxFalloff", props);
		
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
		
		distortionMap = FindProperty("_BumpMap", props);
		distortionAmplitude = FindProperty("_DistortionAmplitude", props);
		distortionScrollSpeedX = FindProperty("_BumpMapScrollSpeedX", props);
		distortionScrollSpeedY = FindProperty("_BumpMapScrollSpeedY", props);

		shakeXAmount = FindProperty("_XShake", props);
		shakeYAmount = FindProperty("_YShake", props);
		shakeXSpeed = FindProperty("_XShakeSpeed", props);
		shakeYSpeed = FindProperty("_YShakeSpeed", props);
		shakeAmplitude = FindProperty("_ShakeAmplitude", props);
		
		overlayImage = FindProperty("_MainTex", props);
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
		
		colorBurningToggle = FindProperty("_Burn", props);
		colorBurningLow = FindProperty("_BurnLow", props);
		colorBurningHigh = FindProperty("_BurnHigh", props);
		
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
		screenXRotationOrigin = FindProperty("_ScreenRotationOriginX", props);
		screenYRotationOrigin = FindProperty("_ScreenRotationOriginY", props);
		screenRotationAngle = FindProperty("_RotationAngle", props);
		
		mirrorReflectionMode = FindProperty("_MirrorMode", props);
	}
	
	public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties) {
		FindProperties(properties);
		
		if (!initialized) {
			customRenderQueue = (materialEditor.target as Material).shader.renderQueue;
			initialized = true;
		}
		
		GUIStyle defaultStyle = new GUIStyle(EditorStyles.foldout);
		defaultStyle.fontStyle = FontStyle.Bold;
		defaultStyle.onNormal = EditorStyles.boldLabel.onNormal;
		defaultStyle.onFocused = EditorStyles.boldLabel.onFocused;
		
		CSCategory[] categories = new CSCategory[] {
			new CSCategory(Styles.falloffSettingsTitle, defaultStyle, me => {
				me.ShaderProperty(falloffMaxDistance, falloffMaxDistance.displayName);
			}),
			
			new CSCategory(Styles.wobbleSettingsTitle, defaultStyle, me => {
				me.ShaderProperty(wobbleXAmount, wobbleXAmount.displayName);
				me.ShaderProperty(wobbleYAmount, wobbleYAmount.displayName);
				me.ShaderProperty(wobbleXTiling, wobbleXTiling.displayName);
				me.ShaderProperty(wobbleYTiling, wobbleYTiling.displayName);
				if (sliderMode) {
					me.ShaderProperty(wobbleXSpeed, wobbleXSpeed.displayName);
					me.ShaderProperty(wobbleYSpeed, wobbleYSpeed.displayName);
				} else {
					me.FloatProperty(wobbleXSpeed, wobbleXSpeed.displayName);
					me.FloatProperty(wobbleYSpeed, wobbleYSpeed.displayName);
				}
			}),
			
			new CSCategory(Styles.blurSettingsTitle, defaultStyle, me => {
				if (sliderMode) {
					me.ShaderProperty(blurRadius, blurRadius.displayName);
				} else {
					me.FloatProperty(blurRadius, blurRadius.displayName);
				}
				DisplayIntSlider(me, blurSampling, 1, 5);
				me.ShaderProperty(blurSamplingAnimated, blurSamplingAnimated.displayName);
			}),
			
			new CSCategory(Styles.distortionMapSettingsTitle, defaultStyle, me => {
				me.ShaderProperty(distortionMap, distortionMap.displayName);
				if (sliderMode) {
					me.ShaderProperty(distortionAmplitude, distortionAmplitude.displayName);
					me.ShaderProperty(distortionScrollSpeedX, distortionScrollSpeedX.displayName);
					me.ShaderProperty(distortionScrollSpeedY, distortionScrollSpeedY.displayName);
				} else {
					me.FloatProperty(distortionAmplitude, distortionAmplitude.displayName);
					me.FloatProperty(distortionScrollSpeedX, distortionScrollSpeedX.displayName);
					me.FloatProperty(distortionScrollSpeedY, distortionScrollSpeedY.displayName);
				}
			}),
			
			new CSCategory(Styles.screenShakeSettingsTitle, defaultStyle, me => {
				if (sliderMode) {
					me.ShaderProperty(shakeXAmount, shakeXAmount.displayName);
					me.ShaderProperty(shakeYAmount, shakeYAmount.displayName);
					me.ShaderProperty(shakeXSpeed, shakeXSpeed.displayName);
					me.ShaderProperty(shakeYSpeed, shakeYSpeed.displayName);
					me.ShaderProperty(shakeAmplitude, shakeAmplitude.displayName);
				} else {
					me.FloatProperty(shakeXAmount, shakeXAmount.displayName);
					me.FloatProperty(shakeYAmount, shakeYAmount.displayName);
					me.FloatProperty(shakeXSpeed, shakeXSpeed.displayName);
					me.FloatProperty(shakeYSpeed, shakeYSpeed.displayName);
					me.FloatProperty(shakeAmplitude, shakeAmplitude.displayName);
				}
			}),
			
			new CSCategory(Styles.overlaySettingsTitle, defaultStyle, me => {
				BlendModePopup(me);
				me.TexturePropertySingleLine(Styles.overlayImageText, overlayImage, overlayColor);
				me.TextureScaleOffsetProperty(overlayImage);
				me.ShaderProperty(overlayBlendAmount, overlayBlendAmount.displayName);
			}),
			
			new CSCategory(Styles.screenColorAdjustmentsTitle, defaultStyle, me => {
				if (sliderMode) {
					me.ShaderProperty(screenHueAdd, screenHueAdd.displayName);
					me.ShaderProperty(screenSaturationAdd, screenSaturationAdd.displayName);
					me.ShaderProperty(screenValueAdd, screenValueAdd.displayName);
					me.ShaderProperty(screenHueMultiply, screenHueMultiply.displayName);
					me.ShaderProperty(screenSaturationMultiply, screenSaturationMultiply.displayName);
					me.ShaderProperty(screenValueMultiply, screenValueMultiply.displayName);
				} else {
					DisplayVec3Field(me, Styles.hsvAddText, screenHueAdd, screenSaturationAdd, screenValueAdd);
					DisplayVec3Field(me, Styles.hsvMultiplyText, screenHueMultiply, screenSaturationMultiply, screenValueMultiply);
				}
				me.ShaderProperty(screenInversion, screenInversion.displayName);
				me.ShaderProperty(screenColor, screenColor.displayName);
				me.ShaderProperty(colorBurningToggle, colorBurningToggle.displayName);
				if (colorBurningToggle.floatValue == 1) {
					me.ShaderProperty(colorBurningLow, colorBurningLow.displayName);
					me.ShaderProperty(colorBurningHigh, colorBurningHigh.displayName);
				}
			}),
			
			new CSCategory(Styles.screenTransformTitle, defaultStyle, me => {
				me.ShaderProperty(screenBoundaryHandling, screenBoundaryHandling.displayName);
				me.ShaderProperty(zoomAmount, zoomAmount.displayName);
				me.ShaderProperty(pixelationAmount, pixelationAmount.displayName);
				if (sliderMode) {
					me.ShaderProperty(screenXOffsetA, screenXOffsetA.displayName);
					me.ShaderProperty(screenYOffsetA, screenYOffsetA.displayName);
					me.ShaderProperty(screenXOffsetR, screenXOffsetR.displayName);
					me.ShaderProperty(screenYOffsetR, screenYOffsetR.displayName);
					me.ShaderProperty(screenXOffsetG, screenXOffsetG.displayName);
					me.ShaderProperty(screenYOffsetG, screenYOffsetG.displayName);
					me.ShaderProperty(screenXOffsetB, screenXOffsetB.displayName);
					me.ShaderProperty(screenYOffsetB, screenYOffsetB.displayName);
					me.ShaderProperty(screenXMultiplierA, screenXMultiplierA.displayName);
					me.ShaderProperty(screenYMultiplierA, screenYMultiplierA.displayName);
					me.ShaderProperty(screenXMultiplierR, screenXMultiplierR.displayName);
					me.ShaderProperty(screenYMultiplierR, screenYMultiplierR.displayName);
					me.ShaderProperty(screenXMultiplierG, screenXMultiplierG.displayName);
					me.ShaderProperty(screenYMultiplierG, screenYMultiplierG.displayName);
					me.ShaderProperty(screenXMultiplierB, screenXMultiplierB.displayName);
					me.ShaderProperty(screenYMultiplierB, screenYMultiplierB.displayName);
				} else {
					DisplayVec4Field(me, Styles.screenXOffsetText, screenXOffsetR, screenXOffsetG, screenXOffsetB, screenXOffsetA);
					DisplayVec4Field(me, Styles.screenYOffsetText, screenYOffsetR, screenYOffsetG, screenYOffsetB, screenYOffsetA);
					DisplayVec4Field(me, Styles.screenXMultiplierText, screenXMultiplierR, screenXMultiplierG, screenXMultiplierB, screenXMultiplierA);
					DisplayVec4Field(me, Styles.screenYMultiplierText, screenYMultiplierR, screenYMultiplierG, screenYMultiplierB, screenYMultiplierA);
				}
				//me.ShaderProperty(screenXRotationOrigin, screenXRotationOrigin.displayName);
				//me.ShaderProperty(screenYRotationOrigin, screenYRotationOrigin.displayName);
				//me.ShaderProperty(screenRotationAngle, screenRotationAngle.displayName);
			}),
			
			new CSCategory(Styles.targetObjectSettingsTitle, defaultStyle, me => {
				me.ShaderProperty(puffiness, puffiness.displayName);
			}),
			
			new CSCategory(Styles.stencilTitle, defaultStyle, me => {
				DisplayIntSlider(me, stencilRef, 0, 255);
				me.ShaderProperty(stencilComp, stencilComp.displayName);
				me.ShaderProperty(stencilPass, stencilPass.displayName);
				me.ShaderProperty(stencilFail, stencilFail.displayName);
				me.ShaderProperty(stencilZFail, stencilZFail.displayName);
				DisplayIntSlider(me, stencilReadMask, 0, 255);
				DisplayIntSlider(me, stencilWriteMask, 0, 255);
			}),
			
			new CSCategory(Styles.miscSettingsTitle, defaultStyle, me => {
				me.ShaderProperty(cullMode, cullMode.displayName);
				me.ShaderProperty(zTest, zTest.displayName);
				me.ShaderProperty(zWrite, zWrite.displayName);
				ShowColorMaskFlags(me, colorMask);
				me.ShaderProperty(mirrorReflectionMode, mirrorReflectionMode.displayName);
			}),
			
			new CSCategory(Styles.renderQueueExportTitle, defaultStyle, me => {
				Material material = me.target as Material;
				
				customRenderQueue = EditorGUILayout.IntSlider(Styles.customRenderQueueSliderText, customRenderQueue, 0, 5000);
				if (GUILayout.Button(Styles.exportCustomRenderQueueButtonText)) {
					int relativeQueue = customRenderQueue - ((int) UnityEngine.Rendering.RenderQueue.Transparent);
					string newQueueString = "Transparent" + (relativeQueue >= 0 ? "+" : "") + relativeQueue;
					string newShaderPath = "RedMage/Cancerspace Queue " + customRenderQueue;
					
					string shaderPath = AssetDatabase.GetAssetPath(material.shader.GetInstanceID());
					string outputLocation = EditorUtility.SaveFilePanelInProject("Save new shader file", "CancerspaceQueue" + customRenderQueue, "shader", "Please enter a file name to save the custom shader to.");
					
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
	}
	
	void BlendModePopup(MaterialEditor materialEditor) {
		EditorGUI.showMixedValue = overlayBlendMode.hasMixedValue;
		var mode = (BlendMode) overlayBlendMode.floatValue;
		EditorGUI.BeginChangeCheck();
		mode = (BlendMode) EditorGUILayout.Popup(overlayBlendMode.displayName, (int) mode, Styles.blendNames);
		if (EditorGUI.EndChangeCheck()) {
			materialEditor.RegisterPropertyChangeUndo(overlayBlendMode.displayName);
			overlayBlendMode.floatValue = (float) mode;
		}
		EditorGUI.showMixedValue = false;
	}
	
	void DisplayVec3Field(MaterialEditor materialEditor, string displayName, MaterialProperty xProp, MaterialProperty yProp, MaterialProperty zProp) {
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
	
	void DisplayVec4Field(MaterialEditor materialEditor, string displayName, MaterialProperty xProp, MaterialProperty yProp, MaterialProperty zProp, MaterialProperty wProp) {
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
	
	void DisplayIntField(MaterialEditor materialEditor, MaterialProperty property) {
		EditorGUI.showMixedValue = property.hasMixedValue;
		int v = (int) property.floatValue;
		EditorGUI.BeginChangeCheck();
		v = EditorGUILayout.IntField(property.displayName, v);
		if (EditorGUI.EndChangeCheck()) {
			materialEditor.RegisterPropertyChangeUndo(property.displayName);
			property.floatValue = (float) v;
		}
		EditorGUI.showMixedValue = false;
	}
	
	void DisplayIntSlider(MaterialEditor materialEditor, MaterialProperty property, int min, int max) {
		EditorGUI.showMixedValue = property.hasMixedValue;
		int v = (int) property.floatValue;
		EditorGUI.BeginChangeCheck();
		v = EditorGUILayout.IntSlider(property.displayName, v, min, max);
		if (EditorGUI.EndChangeCheck()) {
			materialEditor.RegisterPropertyChangeUndo(property.displayName);
			property.floatValue = (float) v;
		}
		EditorGUI.showMixedValue = false;
	}
	
	void ShowColorMaskFlags(MaterialEditor materialEditor, MaterialProperty property) {
		EditorGUI.showMixedValue = property.hasMixedValue;
		ColorWriteMask v = (ColorWriteMask) ((int) property.floatValue);
		EditorGUI.BeginChangeCheck();
		v = (ColorWriteMask) EditorGUILayout.EnumFlagsField(property.displayName, v);
		if (EditorGUI.EndChangeCheck()) {
			materialEditor.RegisterPropertyChangeUndo(property.displayName);
			int x = (int) v;
			if (x == -1) x = 15;
			property.floatValue = (float) x;
		}
		EditorGUI.showMixedValue = false;
	}
}
