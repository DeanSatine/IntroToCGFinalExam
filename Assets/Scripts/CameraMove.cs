using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMove : MonoBehaviour
{
    public float baseSpeed = 25.0f;
    public float boostMultiplier = 40.0f;
    public float maxBoost = 250.0f;
    [Range(0.01f, 1f)] public float mouseSensitivity = 0.15f; 
    private Vector3 prevMousePosition = new Vector3(255, 255, 255);
    private float boostFactor = 1.0f;

    void Update()
    {
        Vector3 mouseDelta = Input.mousePosition - prevMousePosition;
        Vector3 rotationChange = new Vector3(-mouseDelta.y * mouseSensitivity, mouseDelta.x * mouseSensitivity, 0);
        Vector3 newRotation = new Vector3(transform.eulerAngles.x + rotationChange.x, transform.eulerAngles.y + rotationChange.y, 0);
        transform.eulerAngles = newRotation;
        prevMousePosition = Input.mousePosition;

        Vector3 movementInput = GetMovementInput();

        if (movementInput.sqrMagnitude > 0)
        {
            if (Input.GetKey(KeyCode.LeftShift))
            {
                boostFactor += Time.deltaTime;
                movementInput *= boostFactor * boostMultiplier;
                movementInput = Vector3.ClampMagnitude(movementInput, maxBoost);
            }
            else
            {
                boostFactor = Mathf.Clamp(boostFactor * 0.5f, 1f, 1000f);
                movementInput *= baseSpeed;
            }

            movementInput *= Time.deltaTime;
            transform.Translate(movementInput);
        }

        HandleVerticalMovement();
    }

    private Vector3 GetMovementInput()
    {
        Vector3 velocity = Vector3.zero;

        if (Input.GetKey(KeyCode.W)) velocity += Vector3.forward;
        if (Input.GetKey(KeyCode.S)) velocity += Vector3.back;
        if (Input.GetKey(KeyCode.A)) velocity += Vector3.left;
        if (Input.GetKey(KeyCode.D)) velocity += Vector3.right;

        return velocity;
    }

    private void HandleVerticalMovement()
    {
        if (Input.GetKey(KeyCode.E))
            transform.Translate(Vector3.up * baseSpeed * Time.deltaTime);

        if (Input.GetKey(KeyCode.Q))
            transform.Translate(Vector3.down * baseSpeed * Time.deltaTime);
    }
}
