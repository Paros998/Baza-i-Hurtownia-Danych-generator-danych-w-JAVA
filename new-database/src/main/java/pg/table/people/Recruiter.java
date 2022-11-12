package pg.table.people;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import pg.table.csv.CsvData;

import java.util.UUID;

@Data
@NoArgsConstructor(staticName = "dummy")
@AllArgsConstructor
@Builder
public class Recruiter implements CsvData {
    public static final String TABLE = "Rekruter";
    public static final String COLUMNS = "rekruter_id,imie,nazwisko,email,nr_telefonu";
    private UUID id;
    private String firstName;
    private String lastName;
    private String email;
    private String phoneNumber;

    @Override
    public String toString() {
        return "%s,%s,%s,%s,%s".formatted(
                id,
                firstName,
                lastName,
                email,
                phoneNumber
        );
    }

    @Override
    public String getColumns() {
        return COLUMNS;
    }

    @Override
    public String getData() {
        return this.toString();
    }
}