package model;

import java.io.Serializable;

public class Produk implements Serializable {
    private int id;
    private int idjenis;
    private String kode;
    private String nama;
    private String kondisi;
    private double harga;
    private int stok;
    private String keterangan;
    private String foto;
    private Jenis jenis; //relasi tabel

    //blank constructor
    public Produk() {}

    //setter getter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdjenis() {
        return idjenis;
    }

    public void setIdjenis(int idjenis) {
        this.idjenis = idjenis;
    }

    public String getKode() {
        return kode;
    }

    public void setKode(String kode) {
        this.kode = kode;
    }

    public String getNama() {
        return nama;
    }

    public void setNama(String nama) {
        this.nama = nama;
    }

    public String getKondisi() {
        return kondisi;
    }

    public void setKondisi(String kondisi) {
        this.kondisi = kondisi;
    }

    public double getHarga() {
        return harga;
    }

    public void setHarga(double harga) {
        this.harga = harga;
    }

    public int getStok() {
        return stok;
    }

    public void setStok(int stok) {
        this.stok = stok;
    }

    public String getKeterangan() {
        return keterangan;
    }

    public void setKeterangan(String keterangan) {
        this.keterangan = keterangan;
    }

    public String getFoto() {
        return foto;
    }

    public void setFoto(String foto) {
        this.foto = foto;
    }


    public Jenis getJenis() {
        return jenis;
    }

    public void setJenis(Jenis jenis) {
        this.jenis = jenis;
    }

    @Override
    public String toString() {
        return "Produk{" + "id=" + id + ", idjenis=" + idjenis + ", kode=" + kode + ", nama=" + nama + ", kondisi=" + kondisi + ", harga=" + harga + ", stok=" + stok + ", keterangan=" + keterangan + ", foto=" + foto + ", jenis=" + jenis + '}';
    }






}
