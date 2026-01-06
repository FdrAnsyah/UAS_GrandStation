package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Booking implements Serializable {
    private int id;
    private String bookingCode;
    private Schedule schedule;
    private String passengerName;
    private String passengerPhone;
    private int seats;
    private double totalPrice;
    private LocalDateTime createdAt;
    private String status; // pending, approved, rejected

    public Booking() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public Schedule getSchedule() {
        return schedule;
    }

    public void setSchedule(Schedule schedule) {
        this.schedule = schedule;
    }

    public String getPassengerName() {
        return passengerName;
    }

    public void setPassengerName(String passengerName) {
        this.passengerName = passengerName;
    }

    public String getPassengerPhone() {
        return passengerPhone;
    }

    public void setPassengerPhone(String passengerPhone) {
        this.passengerPhone = passengerPhone;
    }

    public int getSeats() {
        return seats;
    }

    public void setSeats(int seats) {
        this.seats = seats;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Alias methods untuk kompatibilitas dengan JSP
    public String getKodeBooking() {
        return bookingCode;
    }

    public String getStasiun_asal() {
        return schedule != null && schedule.getOrigin() != null ? schedule.getOrigin().getName() : "";
    }

    public String getStasiun_tujuan() {
        return schedule != null && schedule.getDestination() != null ? schedule.getDestination().getName() : "";
    }

    public LocalDateTime getTanggal_berangkat() {
        return schedule != null ? schedule.getDepartTime() : null;
    }

    public int getJumlah_penumpang() {
        return seats;
    }

    public double getHarga() {
        return schedule != null ? schedule.getPrice() : 0;
    }

    public String getNama_pemesan() {
        return passengerName;
    }

    public LocalDateTime getTanggal_sampai() {
        return schedule != null ? schedule.getArriveTime() : null;
    }
}
