using UnityEngine;

public class TextureShift : MonoBehaviour
{
    private Material material;
    private float timer;
    [SerializeField] private float cycleDuration = 1f;
    [SerializeField] private string texturePropertyName;
    [SerializeField] private bool shiftX;
    [SerializeField] private bool shiftY;

    void Start()
    {
        // Get the material from the Renderer
        material = GetComponent<Renderer>().material;
    }

    void Update()
    {
        // Update timer and loop it back if exceeds cycle duration
        timer += Time.deltaTime;
        if (timer > cycleDuration)
        {
            timer -= cycleDuration;
        }

        // Calculate the texture offset from timer
        Vector2 textureOffset = Vector2.zero;
        if (shiftX) textureOffset.x = timer / cycleDuration;
        if (shiftY) textureOffset.y = timer / cycleDuration;

        // Adjust the cycle duration with input keys
        if (Input.GetKeyDown(KeyCode.M)) cycleDuration = 20f;
        if (Input.GetKeyDown(KeyCode.N)) cycleDuration = 1f;

        // Apply the texture
        material.SetTextureOffset(texturePropertyName, textureOffset);
    }
}
