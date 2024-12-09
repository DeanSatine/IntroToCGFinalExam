using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMove : MonoBehaviour
{
    public float speed = 5f;
    public float jumpForce = 0f;
    public bool constrainX = false;
    public bool constrainY = false;
    public bool constrainZ = false;
    [Range(0f, 360f)] public float turnSpeed = 90f; 

    private Rigidbody rb;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        rb.constraints = RigidbodyConstraints.FreezeRotation;
    }

    void Update()
    {
        Vector3 movementInput = Vector3.zero;

        if (Input.GetKey(KeyCode.RightArrow))
            movementInput += transform.forward;
        if (Input.GetKey(KeyCode.LeftArrow))
            movementInput -= transform.forward;

        movementInput = movementInput.normalized * speed;

        if (Input.GetKey(KeyCode.LeftArrow))
            transform.Rotate(Vector3.up, -turnSpeed * Time.deltaTime);
        if (Input.GetKey(KeyCode.RightArrow))
            transform.Rotate(Vector3.up, turnSpeed * Time.deltaTime);

        Vector3 velocity = rb.velocity;
        Vector3 desiredVelocity = movementInput;

        if (!constrainY)
        {
            desiredVelocity.y = velocity.y;
        }

        rb.velocity = desiredVelocity;

        if (Input.GetKeyDown(KeyCode.Space) && Mathf.Abs(rb.velocity.y) < 0.01f)
        {
            rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
        }
    }
}
