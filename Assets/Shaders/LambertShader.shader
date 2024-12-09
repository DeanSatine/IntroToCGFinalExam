Shader "Custom/DeanLambertShader"
{
    Properties
    {
        _SurfaceColor("Surface Color", Color) = (1.0, 1.0, 1.0)
    }

    SubShader
    {
        Tags { "LightMode" = "ForwardBase" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // Custom properties
            uniform float4 _SurfaceColor;

            // Unity-defined properties
            uniform float4 _LightColor0;

            // Vertex input structure
            struct VertexInput
            {
                float4 position : POSITION;
                float3 normal : NORMAL;
            };

            // Vertex output structure
            struct VertexOutput
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // Vertex function
            VertexOutput vert(VertexInput input)
            {
                VertexOutput output;
                
                float3 normalizedNormal = normalize(mul(float4(input.normal, 0.0), unity_WorldToObject).xyz);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float attenuation = 1.0;

                float3 diffuse = attenuation * _LightColor0.rgb * _SurfaceColor.rgb * max(0.0, dot(normalizedNormal, lightDirection));

                output.color = float4(diffuse, 1.0);
                output.position = UnityObjectToClipPos(input.position);

                return output;
            }

            // Fragment function
            float4 frag(VertexOutput input) : COLOR
            {
                return input.color;
            }

            ENDCG
        }
    }
}
