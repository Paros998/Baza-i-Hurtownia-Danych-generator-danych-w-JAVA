package pg.table.people;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import pg.table.csv.CsvData;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor(staticName = "dummy")
@Builder
public class Applicant implements CsvData {
    public static final String TABLE = "Aplikant";
    public static final String COLUMNS = "aplikant_id,imie,nazwisko,data_urodzenia,pesel,doswiadczenie";
    private UUID id;
    private String firstName;
    private String lastName;
    private LocalDate birthDate;
    private String personalNumber;
    private Integer yearsOfExperience;

    @Override
    public String toString() {
        return "%s,%s,%s,%s,%s,%d".formatted(
                id,
                firstName,
                lastName,
                birthDate.format(DateTimeFormatter.ISO_LOCAL_DATE),
                personalNumber,
                yearsOfExperience
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