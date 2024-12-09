Shader "Custom/DeanRimLightShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RimColor ("Rim Color", Color) = (1, 1, 1, 1)
        _RimIntensity ("Rim Intensity", Range (0, 1)) = 0
        _RimPower ("Rim Power", Range (0, 5)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        float4 _RimColor;
        float _RimIntensity;
        float _RimPower;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir;
        };

        float4 rimLight(float4 color, float3 normal, float3 viewDirection)
        {
            float NdotV = 1 - dot(normal, viewDirection);
            NdotV = pow(NdotV, _RimPower);
            NdotV *= _RimIntensity;
            float4 finalColor = lerp(color, _RimColor, NdotV);
            return finalColor;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            IN.worldNormal = normalize(IN.worldNormal);
            IN.viewDir = normalize(IN.viewDir);
            c = rimLight(c, IN.worldNormal, IN.viewDir);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
