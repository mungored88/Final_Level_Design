using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class fogOfWarTrigger : MonoBehaviour
{
    MeshRenderer mesh;
    private void Start()
    {
        mesh = this.GetComponent<MeshRenderer>();
    }
    private void OnTriggerEnter(Collider other)
    {
        if(other.CompareTag("Player")) this.mesh.enabled = false;
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player")) this.mesh.enabled = true;
    }
}
