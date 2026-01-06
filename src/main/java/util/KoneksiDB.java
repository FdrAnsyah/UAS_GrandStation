package util;
import java.sql.Connection;
import java.sql.DriverManager;

public class KoneksiDB {

    public static Connection getConnection() {
        try {
            // Kamu bisa override lewat Environment Variable:
            // DB_URL, DB_USER, DB_PASS
            // Contoh:
            // DB_URL=jdbc:postgresql://localhost:5432/dbkeretaku
            String url = System.getenv().getOrDefault("DB_URL", "jdbc:postgresql://localhost:5432/dbkeretaku");
            String user = System.getenv().getOrDefault("DB_USER", "postgres");
            String pass = System.getenv().getOrDefault("DB_PASS", "Sayapunyapostgre");
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            e.printStackTrace(); // WAJIB
            System.out.println("Koneksi gagal: " + e.getMessage());
            return null;
        }
    }
    public static void main(String[] args) {
        if (KoneksiDB.getConnection() != null) {
            System.out.println("Koneksi berhasil");
        }
    } 
}
