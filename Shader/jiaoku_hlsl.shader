Shader "Unlit/jiaoku_hlsl"
{
    Properties
    {
        Tex0("Tex0", 2D) = "white" {}
        Tex1("Tex1", 2D) = "white" {}
        Tex2("Tex2", 2D) = "white" {}
        DetailTex("DetailTex", 2D) = "white" {}
        ShadowMap("ShadowMap", 2D) = "white" {}
        ReflectionProbeA("ReflectionProbeA", CUBE) = "white"{}
        ReflectionProbeB("ReflectionProbeB", CUBE) = "white" {}
        CameraPosition("CameraPosition", vector) = (0,0,0,0)

        _1316("1316", vector) = (0,0,0,0)
         DetailTexTilling("DetailTexTilling", float) = 20
         BaseColor("BaseColor", Color) = (1,1,0,0)
        DetailNormalIntensity("DetailNormalIntencity", Float) = 0.5
        Intensity("Intensity", Vector) = (1,1,1,0)
        // float4 DirLightAttr[5];
        // float4 ShadowInfo;
        // int PointLightNonShadowNum;
        // float4 PointLightAttrs[5];
        // int SpotLightNonShadowNum;
        // float4 SpotLightAttrs[9];
        // float4 ReflectionProbeInfo;
        // float4 ReflectionProbeBoxProjA[3];
        // int2 ReflectionProbeNormalized;
        // float4 ReflectionProbeBoxProjB[3];
        ColorAdjust("ColorAjust", Color) = (0,0,0,0)
        AlphaMtl("AlphaMtl", float ) = 1


    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {  
            //Blend SrcAlpha OneMinusSrcAlpha
            Cull Back
            HLSLPROGRAM
            #pragma prefer_hlslcc gles
            #pragma target 3.5
            #pragma vertex vs_main
            #pragma fragment fs_main 
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "jiaoku_01_input.hlsl"
            #include "jiaoku_01_vs.hlsl"
            #include "jiaoku_01_fs.hlsl"

            ENDHLSL
        }
    }

    CustomEditor "HlslShaderEditor"
}
