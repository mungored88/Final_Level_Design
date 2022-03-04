﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class fogOfWarTrigger : MonoBehaviour
{
    List<GameObject> childrens = new List<GameObject>();
    public Player _player;
    public string nameOfZone;
    private void Start()
    {
        nameOfZone = this.gameObject.name;
        for (int i = 0; i < this.transform.childCount; i++)
        {
            var child = this.transform.GetChild(i).gameObject;
            if (child != null)
                childrens.Add(child);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player")) {
            if (!_player) _player = other.GetComponent<Player>();
            bool thisIsSnowObject = this.gameObject.layer == 18;
            _player.isSnow = thisIsSnowObject;

                foreach (GameObject child in childrens)
                {
                    child.SetActive(false);
                }

        };
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        { 
            foreach (GameObject child in childrens)
            {
                child.SetActive(true);
            }
        };
    }
}
