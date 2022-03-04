using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Weapon : MonoBehaviour , IInteractable, ICollectable<Weapon>

{
    [Header("Sounds")]
    public AudioSource shootSound;
    public AudioSource reloadSound;
    public AudioSource noAmmoSound;
    public AudioSource grabSound;
    WeaponSoundMananger _weaponSoundMananger;

    public LineRenderer[] laserLineRenderer;
    public int actualShoot = 0;
    public Player _player;
    public LayerMask mask = new LayerMask();



    protected Ammo ammo;
    protected Bullet bullet;
    protected float realoadTime = 2;
    private bool reloading = false;
    protected Transform bulletOrigin;
    protected Transform[] bulletOriginBucket;

    protected IFiringMode myCurrentFiringMode;
    protected IFiringMode FMSingleShoot;
    protected IFiringMode FMBurstShoot;
    protected IFiringMode FMAutomaticShoot;
    protected IFiringMode FMBuckShoot;

    protected IFiringMode[] availablesFiringModes;

    private int _currentMode = 0;

    private bool _isPrimary;
    private string _name;

    
    Coroutine shooting;
    Action shoot;

    //List<IObserver> _allObserver = new List<IObserver>(); 

    public event Action<Ammo> onUpdateAmmo;
    public event Action OnGrab;
    public event Action<Weapon> Collect;

    public Action changeFiringMode;

    public Ammo GetAmmo { get { return ammo; } }
    public int AddClips { set { ammo.CLIPS += value; } }
    public Transform BulletOrigin{ get { return bulletOrigin; } set { bulletOrigin = value; }    }
    public Transform[] BulletOriginBucket{ get { return bulletOriginBucket; } set { bulletOriginBucket = value; }    }

    public bool IsPrimary { get { return _isPrimary; } set { _isPrimary = value; } }
    public string Name { get { return _name; } set { _name = value; } }

    protected virtual void Awake()
    {
        FMSingleShoot = new SingleShoot();
        FMBurstShoot =  new BurstShoot();
        FMAutomaticShoot = new AutomaticShoot();
        FMBuckShoot = new BuckShoot();
        
        shoot += ShootOne;
        changeFiringMode += ChangeFiringMode;

        _weaponSoundMananger = new WeaponSoundMananger(this);
    }

    private void Start()
    {
        _player = this.GetComponentInParent<Player>();
    }


    public void GrabThis()
    {
        Collect(this);
        HideWeapon();
        _weaponSoundMananger.Grab();
    }

    private void HideWeapon()
    {
        this.GetComponent<MeshRenderer>().enabled = false;
        this.GetComponent<SphereCollider>().enabled = false;
    }
  
    public void ChangeFiringMode()
    {
        _currentMode++;
        myCurrentFiringMode = availablesFiringModes[_currentMode%(availablesFiringModes.Length)];
    }
    public void ChangeFiringType(FiringType ft)
    {
        if (ft == FiringType.SINGLESHOOT) shoot = ShootOne;
        else if (ft == FiringType.BUCKETSHOOT) shoot = ShootBuck;
    }

    public void Shoot()
    {
        Vector3 direction = _player.transform.TransformDirection(Vector3.forward);
        float length = 500f;

        Ray ray = new Ray(bulletOrigin.position, direction);
        RaycastHit raycastHit;
        Vector3 endPosition = bulletOrigin.position + (length * direction);

        if (Physics.Raycast(ray, out raycastHit, length, mask))
        {
            endPosition = raycastHit.point;

            if(raycastHit.collider.GetComponent<DestroyableObject>() != null)
                raycastHit.collider.gameObject.GetComponent<DestroyableObject>().DestroyObject();
        }

        laserLineRenderer[actualShoot % laserLineRenderer.Length].SetPosition(0, bulletOrigin.position);
        laserLineRenderer[actualShoot% laserLineRenderer.Length].SetPosition(1, endPosition);
        actualShoot++;


        //RaycastHit hit;
        //// Does the ray intersect any objects excluding the player layer
        //if (Physics.Raycast(bulletOrigin.position, bulletOrigin.TransformDirection(Vector3.forward), out hit, Mathf.Infinity))
        //{
        //    Debug.DrawRay(bulletOrigin.position, bulletOrigin.TransformDirection(Vector3.forward) * hit.distance, Color.yellow);
        //    Debug.Log("Did Hit");
        //}
        //else
        //{
        //    Debug.DrawRay(bulletOrigin.position, bulletOrigin.TransformDirection(Vector3.forward) * 1000, Color.white);
        //    Debug.Log("Did not Hit");
        //}


        //if (myCurrentFiringMode != null)
        //{
        //    shooting = StartCoroutine(myCurrentFiringMode.Shoot(shoot));
        //}
    }

    public void StopShoot()
    {
        if (shooting == null) return;
        StopCoroutine(shooting);
    }

    void ShootOne()
    {
        if (ammo.AMMO <= 0) { _weaponSoundMananger.NoAmmo(); return; }

        Bullet b = BulletSpawner.Instance.pool.GetObject().SetPosition(bulletOrigin);
        //ammo.AMMO--;
        onUpdateAmmo(ammo);
        _weaponSoundMananger.Shoot();


    }
    void ShootBuck()
    {
        if (ammo.AMMO <= 0) { _weaponSoundMananger.NoAmmo(); return; }
        ammo.AMMO--;
        onUpdateAmmo(ammo);


        foreach (Transform t in BulletOriginBucket)
        {
            BulletSpawner.Instance.pool.GetObject().SetPosition(t);
        }

        _weaponSoundMananger.Shoot();
    }


    public void Reload()
    {
        if (reloading) return;
        if (ammo.CLIPS == 0) return;
        reloading = true;
        _weaponSoundMananger.Reload();
        StartCoroutine(ReloadWait());
    }
    IEnumerator ReloadWait() {
        yield return new WaitForSeconds(realoadTime);

        reloading = false;
        ammo.AMMO = ammo.MAX_LOADED_AMMO;
        ammo.CLIPS--;
        onUpdateAmmo(ammo);
        yield return null;
    }

}

public struct Ammo
{
    public int AMMO;
    public int MAX_LOADED_AMMO;
    public int CLIPS;
}

public enum FiringType
{
    SINGLESHOOT,
    BUCKETSHOOT,
}

