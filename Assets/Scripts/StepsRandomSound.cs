using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StepsRandomSound : MonoBehaviour
{
    [SerializeField]
    private AudioClip[] clips;
    [SerializeField]
    private AudioClip[] clipsSnow;
    public AudioSource audioSource;
    public AudioSource audioSourceSnow;
    private Player _player;
    // Start is called before the first frame update
    void Start()
    {
        audioSource = GetComponent<AudioSource>();
        _player = GetComponent<Player>();
    }

    private void step()
    {
        AudioClip clip = GetRandomClip();
        if (!_player.isSnow)
            audioSource.PlayOneShot(clip);
        else
            audioSourceSnow.PlayOneShot(clip);

    }
    private AudioClip GetRandomClip()
    {
        if (!_player.isSnow)
            return clips[UnityEngine.Random.Range(0, clips.Length)];
        else
            return clipsSnow[UnityEngine.Random.Range(0, clipsSnow.Length)];
    }
}
