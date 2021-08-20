#ifdef FRAGMENT

#define NEOX_USE_POSITION_INVARIANT 0


uniform float DetailNormalIntensity;
uniform float DetailTexTilling;
uniform vec4 BaseColor;
uniform vec4 Intensity;
uniform vec2 ColorAdjust;
uniform vec4 ReflectionProbeInfo;
uniform vec4 ReflectionProbeBoxProjA[3];
uniform ivec2 ReflectionProbeNormalized;
uniform vec4 ReflectionProbeBoxProjB[3];
uniform vec4 DirLightAttr[5];
uniform vec4 ShadowInfo;
uniform vec4 PointLightAttrs[5];
uniform int PointLightNonShadowNum;
uniform vec4 FillLightColor;
uniform vec4 FillLightDirection;
uniform vec4 SpotLightAttrs[9];
uniform int SpotLightNonShadowNum;
uniform vec4 CameraPosition;
uniform float AlphaMtl;
uniform highp sampler2D Tex0;
uniform highp sampler2D Tex1;
uniform highp sampler2D Tex2;
uniform highp sampler2D DetailTex;
uniform highp sampler2D ShadowMap;
uniform highp samplerCube ReflectionProbeA;
uniform highp samplerCube ReflectionProbeB;

layout(location = 1)in vec3 v2f_position_world;
layout(location = 4)in vec3 v2f_normal;
layout(location = 5)in vec3 v2f_tangent;
layout(location = 6)in vec3 v2f_binormal;
layout(location = 7)in vec4 v2f_sh;
layout(location = 9)in vec4 v2f_uv;
layout(location = 10)in vec4 v2f_shadow_pos;
layout(location=0) out vec4 _entryPointOutput;

void main()
{
    vec3 _2128 = v2f_position_world - CameraPosition.xyz;
    vec3 _2139 = _2128 / vec3(length(_2128));
    vec4 _2219 = texture(Tex0, v2f_uv.xy);
    vec4 _2226 = texture(Tex1, v2f_uv.xy);
    vec4 _2233 = texture(Tex2, v2f_uv.xy);
    vec4 _2242 = texture(DetailTex, v2f_uv.xy * DetailTexTilling);
    vec2 _2260 = mix(_2233.xy, _2242.wz, vec2(_2226.z));
    vec3 _2326 = _2219.xyz * BaseColor.xyz;
    vec3 _2353 = (_2226.xyz * 2.0) - vec3(1.0);
    vec3 _5355 = _2353;
    _5355.z = sqrt(1.0 - dot(_2353.xy, _2353.xy));
    vec2 _2397 = ((_2242.xy * 2.0) - vec2(1.0)).xy * (DetailNormalIntensity * _2226.z);
    vec4 _5357 = vec4(_2397.x, _2397.y, _2242.z, _2242.w);
    _5357.z = sqrt(1.0 - dot(_2397.xy, _2397.xy));
    vec3 _2423 = normalize(vec3(_5355.xy + _5357.xy, _5355.z));
    vec2 _2362 = _2423.xy * Intensity.x;
    vec3 _2372 = normalize(mat3(v2f_tangent, v2f_binormal, v2f_normal) * normalize(vec3(_2362.x, _2362.y, _2423.z)));
    vec3 _2444 = dFdx(_2372);
    vec3 _2446 = dFdy(_2372);
    float _2297 = max(clamp(_2260.y * Intensity.y, 0.0900000035762786865234375, 1.0), clamp((pow(max(max(dot(_2444, _2444), dot(_2446, _2446)), 9.9999997473787516355514526367188e-05), 0.5) * 2.0) - 0.20000000298023223876953125, 0.0, 1.0));
    float _2467 = clamp(_2233.z * Intensity.z, 0.0, 1.0);
    float _2470 = _2260.x;
    float _2472 = _2226.w;
    float _2576 = dot(-_2139, _2372);
    float _2582 = clamp(abs(_2576) + 9.9999997473787516355514526367188e-06, 0.0, 1.0);
    vec3 _2602 = mix(vec3(0.039999999105930328369140625), _2326, vec3(_2467));
    vec3 _2607 = _2326 * (1.0 - _2467);
    float _2589 = max(0.00999999977648258209228515625, _2297);
    float _2611 = _2589 * _2589;
    vec3 _2594 = reflect(_2139, _2372);
    vec3 _5266;
    vec3 _5267;
    _5267 = vec3(0.0);
    _5266 = vec3(0.0);
    vec3 _5337 = vec3(0.0);
    vec3 _5338 = vec3(0.0);
    for (int _5264 = 0; _5264 < 1; _5267 = _5338, _5266 = _5337, _5264++)
    {
        float _2654 = dot(_2372, -DirLightAttr[3].xyz);
        if (_2654 <= 0.0)
        {
            _5338 = _5267;
            _5337 = _5266;
            continue;
        }
        vec4 _2742 = v2f_shadow_pos / vec4(v2f_shadow_pos.w);
        vec3 _2744 = _2742.xyz;
        float _5310;
        if (_2744.z > 1.0)
        {
            _5310 = 1.0;
        }
        else
        {
            _5310 = (textureLod(ShadowMap, _2742.xy, 0.0).x < _2744.z) ? 0.0 : 1.0;
        }
        float _2669 = _5310 + ShadowInfo.w;
        float _2673 = min(1.0, clamp(_2669, 0.0, 1.0));
        float _2771 = max(_2654, 0.0);
        float _2775 = dot(DirLightAttr[3].xyz, _2139);
        float _2780 = inversesqrt(max(2.0 + (2.0 * _2775), 9.9999997473787516355514526367188e-06));
        float _2800 = 1.0 - clamp(_2780 + (_2780 * _2775), 0.0, 1.0);
        float _2816 = _2800 * _2800;
        float _2821 = (_2816 * _2816) * _2800;
        float _2886 = _2611 * _2611;
        float _2888 = min(0.999000012874603271484375, clamp((_2654 + _2576) * _2780, 0.0, 1.0));
        float _2896 = (((_2888 * _2886) - _2888) * _2888) + 1.0;
        float _5322;
        if ((_2673 <= 1.0) && (_2673 >= 0.0))
        {
            _5322 = _2673;
        }
        else
        {
            _5322 = 1.0;
        }
        _5338 = _5267 + ((((vec3(_2771) * _2607) * 1.0) * _5322) * DirLightAttr[1].xyz);
        _5337 = _5266 + ((((vec3(max(0.0, ((0.5 / max((_2771 * ((_2582 * (1.0 - _2611)) + _2611)) + (_2582 * ((_2771 * (1.0 - _2611)) + _2611)), 9.9999997473787516355514526367188e-06)) * (_2886 / ((3.1415927410125732421875 * _2896) * _2896))) * _2771)) * (vec3(clamp(50.0 * _2602.y, 0.0, 1.0) * _2821) + (_2602 * (1.0 - _2821)))) * 1.0) * _5322) * DirLightAttr[1].xyz);
    }
    vec3 _5281;
    vec3 _5282;
    if (min(PointLightNonShadowNum, 1) == 1)
    {
        vec3 _2949 = v2f_position_world - PointLightAttrs[3].xyz;
        float _2953 = length(_2949);
        vec3 _2958 = _2949 / vec3(_2953);
        float _2964 = dot(_2372, -_2958);
        vec3 _5269;
        vec3 _5270;
        if (!(_2964 <= 0.0))
        {
            float _3025 = max(_2964, 0.0);
            float _3029 = dot(_2958, _2139);
            float _3034 = inversesqrt(max(2.0 + (2.0 * _3029), 9.9999997473787516355514526367188e-06));
            float _3054 = 1.0 - clamp(_3034 + (_3034 * _3029), 0.0, 1.0);
            float _3070 = _3054 * _3054;
            float _3075 = (_3070 * _3070) * _3054;
            float _3085 = _2953 * _2953;
            float _3091 = (_3085 * PointLightAttrs[3].w) * PointLightAttrs[3].w;
            float _3094 = clamp(1.0 - (_3091 * _3091), 0.0, 1.0);
            float _3098 = (1.0 / (_3085 + 1.0)) * (_3094 * _3094);
            float _3171 = _2611 * _2611;
            float _3173 = min(0.999000012874603271484375, clamp((_2964 + _2576) * _3034, 0.0, 1.0));
            float _3181 = (((_3173 * _3171) - _3173) * _3173) + 1.0;
            _5270 = _5267 + ((((vec3(_3025) * _2607) * _3098) * PointLightAttrs[1].xyz) * _2472);
            _5269 = _5266 + ((((vec3(max(0.0, ((0.5 / max((_3025 * ((_2582 * (1.0 - _2611)) + _2611)) + (_2582 * ((_3025 * (1.0 - _2611)) + _2611)), 9.9999997473787516355514526367188e-06)) * (_3171 / ((3.1415927410125732421875 * _3181) * _3181))) * _3025)) * (vec3(clamp(50.0 * _2602.y, 0.0, 1.0) * _3075) + (_2602 * (1.0 - _3075)))) * _3098) * PointLightAttrs[1].xyz) * _2472);
        }
        else
        {
            _5270 = _5267;
            _5269 = _5266;
        }
        _5282 = _5270;
        _5281 = _5269;
    }
    else
    {
        _5282 = _5267;
        _5281 = _5266;
    }
    vec3 _5296;
    vec3 _5297;
    if (min(SpotLightNonShadowNum, 1) == 1)
    {
        vec3 _3236 = v2f_position_world - SpotLightAttrs[3].xyz;
        float _3240 = length(_3236);
        vec3 _3245 = _3236 / vec3(_3240);
        float _3251 = dot(_2372, -_3245);
        vec3 _5284;
        vec3 _5285;
        if (!(_3251 <= 0.0))
        {
            vec3 _3274 = SpotLightAttrs[1].xyz * 16.0;
            float _3330 = max(_3251, 0.0);
            float _3334 = dot(_3245, _2139);
            float _3339 = inversesqrt(max(2.0 + (2.0 * _3334), 9.9999997473787516355514526367188e-06));
            float _3359 = 1.0 - clamp(_3339 + (_3339 * _3334), 0.0, 1.0);
            float _3375 = _3359 * _3359;
            float _3380 = (_3375 * _3375) * _3359;
            float _3390 = _3240 * _3240;
            float _3396 = (_3390 * SpotLightAttrs[3].w) * SpotLightAttrs[3].w;
            float _3399 = clamp(1.0 - (_3396 * _3396), 0.0, 1.0);
            float _3426 = clamp((dot(-_3245, -normalize(SpotLightAttrs[0].xyz)) - SpotLightAttrs[4].xy.x) * SpotLightAttrs[4].xy.y, 0.0, 1.0);
            float _3292 = (_3426 * _3426) * ((1.0 / (_3390 + 1.0)) * (_3399 * _3399));
            float _3496 = _2611 * _2611;
            float _3498 = min(0.999000012874603271484375, clamp((_3251 + _2576) * _3339, 0.0, 1.0));
            float _3506 = (((_3498 * _3496) - _3498) * _3498) + 1.0;
            _5285 = _5282 + (((vec3(_3330) * _2607) * _3292) * _3274);
            _5284 = _5281 + (((vec3(max(0.0, ((0.5 / max((_3330 * ((_2582 * (1.0 - _2611)) + _2611)) + (_2582 * ((_3330 * (1.0 - _2611)) + _2611)), 9.9999997473787516355514526367188e-06)) * (_3496 / ((3.1415927410125732421875 * _3506) * _3506))) * _3330)) * (vec3(clamp(50.0 * _2602.y, 0.0, 1.0) * _3380) + (_2602 * (1.0 - _3380)))) * _3292) * _3274);
        }
        else
        {
            _5285 = _5282;
            _5284 = _5281;
        }
        _5297 = _5285;
        _5296 = _5284;
    }
    else
    {
        _5297 = _5282;
        _5296 = _5281;
    }
    vec3 _5302;
    vec3 _5303;
    for (;;)
    {
        vec3 _3546 = FillLightDirection.xyz / vec3(length(FillLightDirection.xyz));
        float _3552 = dot(_2372, -_3546);
        if (_3552 <= 0.0)
        {
            _5303 = _5297;
            _5302 = _5296;
            break;
        }
        float _3605 = max(_3552, 0.0);
        float _3609 = dot(_3546, _2139);
        float _3614 = inversesqrt(max(2.0 + (2.0 * _3609), 9.9999997473787516355514526367188e-06));
        float _3634 = 1.0 - clamp(_3614 + (_3614 * _3609), 0.0, 1.0);
        float _3650 = _3634 * _3634;
        float _3655 = (_3650 * _3650) * _3634;
        float _3720 = _2611 * _2611;
        float _3722 = min(0.999000012874603271484375, clamp((_3552 + _2576) * _3614, 0.0, 1.0));
        float _3730 = (((_3722 * _3720) - _3722) * _3722) + 1.0;
        _5303 = _5297 + ((((vec3(_3605) * _2607) * 1.0) * FillLightColor.xyz) * 1.0);
        _5302 = _5296 + ((((vec3(max(0.0, ((0.5 / max((_3605 * ((_2582 * (1.0 - _2611)) + _2611)) + (_2582 * ((_3605 * (1.0 - _2611)) + _2611)), 9.9999997473787516355514526367188e-06)) * (_3720 / ((3.1415927410125732421875 * _3730) * _3730))) * _3605)) * (vec3(clamp(50.0 * _2602.y, 0.0, 1.0) * _3655) + (_2602 * (1.0 - _3655)))) * 1.0) * FillLightColor.xyz) * 1.0);
        break;
    }
    vec3 _2540 = _5303 * 0.3183099925518035888671875;
    vec4 _5308;
    if (ReflectionProbeInfo.x > 0.0)
    {
        vec3 _5416;
        if (ReflectionProbeBoxProjA[0].x > 0.0)
        {
            vec3 _3865 = (ReflectionProbeBoxProjA[1].xyz - v2f_position_world) / _2594;
            vec3 _3870 = (ReflectionProbeBoxProjA[2].xyz - v2f_position_world) / _2594;
            vec3 _5372 = _3865;
            _5372.x = (_2594.x > 0.0) ? _3865.x : _3870.x;
            vec3 _5377 = _5372;
            _5377.y = (_2594.y > 0.0) ? _3865.y : _3870.y;
            vec3 _5382 = _5377;
            _5382.z = (_2594.z > 0.0) ? _3865.z : _3870.z;
            _5416 = (v2f_position_world - ReflectionProbeBoxProjA[0].yzw) + (_2594 * min(min(_5382.x, _5382.y), _5382.z));
        }
        else
        {
            _5416 = _2594;
        }
        vec4 _3799 = textureLod(ReflectionProbeA, _5416, _2297 * ReflectionProbeInfo.y);
        vec4 _5307;
        if (ReflectionProbeNormalized.x == 1)
        {
            vec3 _3807 = _3799.xyz * v2f_sh.xyz;
            _5307 = vec4(_3807.x, _3807.y, _3807.z, _3799.w);
        }
        else
        {
            _5307 = _3799;
        }
        vec4 _5309;
        if (ReflectionProbeInfo.x < 0.999989986419677734375)
        {
            vec3 _5417;
            if (ReflectionProbeBoxProjB[0].x > 0.0)
            {
                vec3 _3929 = (ReflectionProbeBoxProjB[1].xyz - v2f_position_world) / _2594;
                vec3 _3934 = (ReflectionProbeBoxProjB[2].xyz - v2f_position_world) / _2594;
                vec3 _5390 = _3929;
                _5390.x = (_2594.x > 0.0) ? _3929.x : _3934.x;
                vec3 _5395 = _5390;
                _5395.y = (_2594.y > 0.0) ? _3929.y : _3934.y;
                vec3 _5400 = _5395;
                _5400.z = (_2594.z > 0.0) ? _3929.z : _3934.z;
                _5417 = (v2f_position_world - ReflectionProbeBoxProjB[0].yzw) + (_2594 * min(min(_5400.x, _5400.y), _5400.z));
            }
            else
            {
                _5417 = _2594;
            }
            vec4 _3831 = textureLod(ReflectionProbeB, _5417, _2297 * ReflectionProbeInfo.z);
            vec4 _5304;
            if (ReflectionProbeNormalized.y == 1)
            {
                vec3 _3839 = _3831.xyz * v2f_sh.xyz;
                _5304 = vec4(_3839.x, _3839.y, _3839.z, _3831.w);
            }
            else
            {
                _5304 = _3831;
            }
            _5309 = mix(_5304, _5307, vec4(ReflectionProbeInfo.x));
        }
        else
        {
            _5309 = _5307;
        }
        _5308 = _5309;
    }
    else
    {
        _5308 = vec4(0.0);
    }
    vec4 _3986 = (vec4(-1.0, -0.0274999998509883880615234375, -0.572000026702880859375, 0.02199999988079071044921875) * _2297) + vec4(1.0, 0.0425000004470348358154296875, 1.03999996185302734375, -0.039999999105930328369140625);
    vec2 _4006 = (vec2(-1.03999996185302734375, 1.03999996185302734375) * ((min(_3986.x * _3986.x, exp2((-9.27999973297119140625) * _2576)) * _3986.x) + _3986.y)) + _3986.zw;
    vec3 _2177 = ((_2540 + _5302) + ((v2f_sh.xyz * _2607) * _2470)) + ((((_2602 * _4006.x) + vec3(_4006.y)) * _5308.xyz) * _2470);
    _entryPointOutput = vec4(_2177 + (max(vec3(0.0), _2177 + ((_2177 - vec3(0.5 * (max(_2177.x, max(_2177.y, _2177.z)) + min(_2177.x, min(_2177.y, _2177.z))))) * ColorAdjust.x)) * ColorAdjust.y), (_2219.w * BaseColor.w) * AlphaMtl);
   
}

#endif