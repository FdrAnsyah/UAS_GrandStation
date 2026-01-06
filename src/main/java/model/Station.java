package model;

import java.io.Serializable;

public class Station implements Serializable {
    private int id;
    private String code;
    private String name;
    private String city;

    public Station() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getLabel() {
        // Dipakai buat dropdown (contoh: "GMR - Gambir (Jakarta)")
        String c = (code == null) ? "" : code;
        String n = (name == null) ? "" : name;
        String ct = (city == null || city.isBlank()) ? "" : " (" + city + ")";
        return c + " - " + n + ct;
    }
}
