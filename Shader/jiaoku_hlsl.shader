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
         BaseColor("BaseColor", Color) = (1,1,1,0)
        DetailNormalIntensity("DetailNormalIntencity", Float) = 0.5
        Intensity("Intensity", Vector) = (1,1,1,0)
        AdditionLightDir("DirLightDir", Vector) = (0,-1,0,0)
        AdditionLightColor("AdditionLightColor", Color) = (0.5,0.5,0.5,0)
        // float4 DirLightAttr[5];
        ShadowInfo("ShadowInfo", Vector) = (0.44125, -0.45671, -0.7724, 0)
        // int PointLightNonShadowNum;
        // float4 PointLightAttrs[5];
        // int SpotLightNonShadowNum;
        // float4 SpotLightAttrs[9];
        ReflectionProbeInfo("ReflectionProbeInfo", Vector) = (1,7,-0.7724, 0)
        // float4 ReflectionProbeBoxProjA[3];
        // int2 ReflectionProbeNormalized;
        // float4 ReflectionProbeBoxProjB[3];
        ColorAdjust("ColorAjust", Color) = (0,0,0,0)
        AlphaMtl("AlphaMtl", float ) = 1


    }
    SubShader
    {
        Tags { "RenderType"="Opaque"  }
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

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "jiaoku_01_input.hlsl"
            #include "jiaoku_01_vs.hlsl"
            #include "jiaoku_01_fs.hlsl"

            ENDHLSL
        }



        Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            #pragma only_renderers gles gles3 glcore d3d11
            #pragma target 2.0

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }

        
    }

    CustomEditor "HlslShaderEditor"
}
