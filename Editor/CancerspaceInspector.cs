using UnityEditor;
using UnityEngine;
using System;

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
		Lighten
	}
	
	public static class Styles {
		public static GUIContent overlayImageText = new GUIContent("Image Overlay", "The overlay image and color.");
		public static string targetObjectSettingsTitle = "Target Object Settings";
		public static string falloffSettingsTitle = "Falloff Settings";
		public static string wobbleSettingsTitle = "Wobbling";
		public static string screenShakeSettingsTitle = "Screen Shake";
		public static string overlaySettingsTitle = "Overlay";
		public static string screenColorAdjustmentsTitle = "Screen Color Adjustment";
		public static string screenTransformTitle = "Screen Transformations";
		public static string miscSettingsTitle = "Misc";
		
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
	
	protected MaterialProperty categoryExpansionFlags;
	
	protected MaterialProperty cullMode;
	protected MaterialProperty zTest;
	
	protected MaterialProperty puffiness;
	
	protected MaterialProperty falloffMaxDistance;
	
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
	
	protected MaterialProperty overlayImage;
	protected MaterialProperty overlayColor;
	protected MaterialProperty overlayBlendAmount;
	protected MaterialProperty overlayBlendMode;
	
	protected MaterialProperty screenHSVAdd;
	protected MaterialProperty screenHSVMultiply;
	protected MaterialProperty screenInversion;
	protected MaterialProperty screenColor;
	
	protected MaterialProperty colorBurningToggle;
	protected MaterialProperty colorBurningLow;
	protected MaterialProperty colorBurningHigh;
	
	protected MaterialProperty screenBoundaryHandling;
	protected MaterialProperty screenXOffset;
	protected MaterialProperty screenYOffset;
	protected MaterialProperty screenXMultiplier;
	protected MaterialProperty screenYMultiplier;
	protected MaterialProperty screenXRotationOrigin;
	protected MaterialProperty screenYRotationOrigin;
	protected MaterialProperty screenRotationAngle;
	
	protected MaterialProperty mirrorReflectionMode;
	protected MaterialProperty customRenderQueue;
	
	public void FindProperties(MaterialProperty[] props) {
		categoryExpansionFlags = FindProperty("_InspectorCategoryExpansionFlags", props);
		
		cullMode = FindProperty("_CullMode", props);
		zTest = FindProperty("_ZTest", props);
		
		puffiness = FindProperty("_Puffiness", props);
		
		falloffMaxDistance = FindProperty("_MaxFalloff", props);
		
		zoomAmount = FindProperty("_Zoom", props);
		pixelationAmount = FindProperty("_Pixelation", props);
		
		wobbleXAmount = FindProperty("_XWobbleAmount", props);
		wobbleYAmount = FindProperty("_YWobbleAmount", props);
		wobbleXTiling = FindProperty("_XWobbleTiling", props);
		wobbleYTiling = FindProperty("_YWobbleTiling", props);
		wobbleXSpeed = FindProperty("_XWobbleSpeed", props);
		wobbleYSpeed = FindProperty("_YWobbleSpeed", props);

		shakeXAmount = FindProperty("_XShake", props);
		shakeYAmount = FindProperty("_YShake", props);
		shakeXSpeed = FindProperty("_XShakeSpeed", props);
		shakeYSpeed = FindProperty("_YShakeSpeed", props);
		
		overlayImage = FindProperty("_MainTex", props);
		overlayColor = FindProperty("_OverlayColor", props);
		overlayBlendAmount = FindProperty("_BlendAmount", props);
		overlayBlendMode = FindProperty("_BlendMode", props);
		
		screenHSVAdd = FindProperty("_HSVAdd", props);
		screenHSVMultiply = FindProperty("_HSVMultiply", props);
		screenInversion = FindProperty("_InversionAmount", props);
		screenColor = FindProperty("_Color", props);
		
		colorBurningToggle = FindProperty("_Burn", props);
		colorBurningLow = FindProperty("_BurnLow", props);
		colorBurningHigh = FindProperty("_BurnHigh", props);
		
		screenBoundaryHandling = FindProperty("_ScreenBoundaryHandling", props);
		screenXOffset = FindProperty("_ScreenXOffset", props);
		screenYOffset = FindProperty("_ScreenYOffset", props);
		screenXMultiplier = FindProperty("_ScreenXMultiplier", props);
		screenYMultiplier = FindProperty("_ScreenYMultiplier", props);
		screenXRotationOrigin = FindProperty("_ScreenRotationOriginX", props);
		screenYRotationOrigin = FindProperty("_ScreenRotationOriginY", props);
		screenRotationAngle = FindProperty("_RotationAngle", props);
		
		mirrorReflectionMode = FindProperty("_MirrorMode", props);
	}
	
	public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties) {
		FindProperties(properties);
		
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
				me.ShaderProperty(wobbleXSpeed, wobbleXSpeed.displayName);
				me.ShaderProperty(wobbleYSpeed, wobbleYSpeed.displayName);
			}),
			
			new CSCategory(Styles.screenShakeSettingsTitle, defaultStyle, me => {
				me.ShaderProperty(shakeXAmount, shakeXAmount.displayName);
				me.ShaderProperty(shakeYAmount, shakeYAmount.displayName);
				me.ShaderProperty(shakeXSpeed, shakeXSpeed.displayName);
				me.ShaderProperty(shakeYSpeed, shakeYSpeed.displayName);
			}),
			
			new CSCategory(Styles.overlaySettingsTitle, defaultStyle, me => {
				BlendModePopup(me);
				me.TexturePropertySingleLine(Styles.overlayImageText, overlayImage, overlayColor);
				me.TextureScaleOffsetProperty(overlayImage);
				me.ShaderProperty(overlayBlendAmount, overlayBlendAmount.displayName);
			}),
			
			new CSCategory(Styles.screenColorAdjustmentsTitle, defaultStyle, me => {
				DisplayVec3Field(me, screenHSVAdd);
				DisplayVec3Field(me, screenHSVMultiply);
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
				me.ShaderProperty(screenXOffset, screenXOffset.displayName);
				me.ShaderProperty(screenYOffset, screenYOffset.displayName);
				me.ShaderProperty(screenXMultiplier, screenXMultiplier.displayName);
				me.ShaderProperty(screenYMultiplier, screenYMultiplier.displayName);
				me.ShaderProperty(screenXRotationOrigin, screenXRotationOrigin.displayName);
				me.ShaderProperty(screenYRotationOrigin, screenYRotationOrigin.displayName);
				me.ShaderProperty(screenRotationAngle, screenRotationAngle.displayName);
			}),
			
			new CSCategory(Styles.targetObjectSettingsTitle, defaultStyle, me => {
				me.ShaderProperty(puffiness, puffiness.displayName);
			}),
			
			new CSCategory(Styles.miscSettingsTitle, defaultStyle, me => {
				me.ShaderProperty(cullMode, cullMode.displayName);
				me.ShaderProperty(zTest, zTest.displayName);
				me.ShaderProperty(mirrorReflectionMode, mirrorReflectionMode.displayName);
			}),
		};
		
		EditorGUIUtility.labelWidth = 0f;
		
		int oldflags = BitConverter.ToInt32(BitConverter.GetBytes(categoryExpansionFlags.floatValue), 0);
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
		categoryExpansionFlags.floatValue = BitConverter.ToSingle(BitConverter.GetBytes(newflags), 0);
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
	
	void DisplayVec3Field(MaterialEditor materialEditor, MaterialProperty property) {
		EditorGUI.showMixedValue = property.hasMixedValue;
		Vector4 v0 = property.vectorValue;
		EditorGUI.BeginChangeCheck();
		Vector3 v = EditorGUILayout.Vector3Field(property.displayName, new Vector3(v0.x, v0.y, v0.z));
		if (EditorGUI.EndChangeCheck()) {
			materialEditor.RegisterPropertyChangeUndo(property.displayName);
			property.vectorValue = new Vector4(v.x, v.y, v.z, 0);
		}
		EditorGUI.showMixedValue = false;
	}
}
