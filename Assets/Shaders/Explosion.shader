Shader "Custom/DeanExplosionShader"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1,1,1,1)
        _Texture("Main Texture (RGB)", 2D) = "white" {}
        _DisplacementTexture("Displacement Map", 2D) = "black" {}
        _DisplacementStrength("Displacement Intensity", Range(0, 1)) = 0.3
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"

            fixed4 _BaseColor;
            sampler2D _Texture;
            sampler2D _DisplacementTexture;
            half _DisplacementStrength;
            float4 _Texture_ST;
            float4 _DisplacementTexture_ST;

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct VertexOutput
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.uv = TRANSFORM_TEX(v.uv, _Texture);

                float displacementValue = tex2Dlod(_DisplacementTexture, float4(o.uv, 0, 0)).r;
                float4 displacedVertex = float4(v.vertex.x, v.vertex.y, v.vertex.z, 1.0);
                displacedVertex.xyz += displacementValue * v.normal * _DisplacementStrength * _Time;

                o.vertex = UnityObjectToClipPos(displacedVertex);

                return o;
            }

            fixed4 frag(VertexOutput i) : SV_Target
            {
                fixed4 colorOutput = tex2D(_Texture, i.uv) * _BaseColor;
                return colorOutput;
            }
            ENDCG
        }
    }
}
