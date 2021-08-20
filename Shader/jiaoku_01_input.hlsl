

#ifndef SHADER_INPUT
#define SHADER_INPUT

CBUFFER_START(UnityPerMaterial)


// float4x4 World;
// float4x4 ViewProjection;
// float4x4 InverseWorld;
float3 _1316;
float4 LightProbeSHLow[3];
float4x4 LightViewProj[4];
float3 CameraPosition;
float DetailTexTilling;
float4 BaseColor;
float DetailNormalIntensity;
float4 Intensity;
float4 DirLightAttr[5];
float4 ShadowInfo;
int PointLightNonShadowNum;
float4 PointLightAttrs[5];
int SpotLightNonShadowNum;
float4 SpotLightAttrs[9];
float4 FillLightDirection;
float4 FillLightColor;
float4 ReflectionProbeInfo;
float4 ReflectionProbeBoxProjA[3];
int2 ReflectionProbeNormalized;
float4 ReflectionProbeBoxProjB[3];
float2 ColorAdjust;
float AlphaMtl;


CBUFFER_END
#endif


#define World unity_ObjectToWorld
#define ViewProjection UNITY_MATRIX_VP
#define InverseWorld unity_MatrixInvV
