using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PixelFilter : MonoBehaviour
{
    public Material Material;
    public int intensity = 64;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Vector2 aspectRatioAdjuster;

        if (Screen.height > Screen.width)
            aspectRatioAdjuster = new Vector2((float)Screen.width / Screen.height, 1);
        else
            aspectRatioAdjuster = new Vector2(1, (float)Screen.height / Screen.width);

        Material.SetVector("_AspectRatioMultiplier", aspectRatioAdjuster);
        Material.SetInt("_PixelDensity", intensity);
        Graphics.Blit(source, destination, Material);
    }
}
