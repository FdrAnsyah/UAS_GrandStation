package model;

import java.io.Serializable;

public class Train implements Serializable {
    private int id;
    private String code;
    private String name;
    private String trainClass; // Eksekutif/Bisnis/Ekonomi
    private int seatsTotal;

    public Train() {}

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

    public String getTrainClass() {
        return trainClass;
    }

    public void setTrainClass(String trainClass) {
        this.trainClass = trainClass;
    }

    public int getSeatsTotal() {
        return seatsTotal;
    }

    public void setSeatsTotal(int seatsTotal) {
        this.seatsTotal = seatsTotal;
    }

    public String getLabel() {
        String c = (code == null) ? "" : code;
        String n = (name == null) ? "" : name;
        String tc = (trainClass == null || trainClass.isBlank()) ? "" : " · " + trainClass;
        return c + " - " + n + tc;
    }
}
