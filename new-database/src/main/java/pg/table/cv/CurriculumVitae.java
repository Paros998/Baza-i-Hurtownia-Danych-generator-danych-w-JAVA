package pg.table.cv;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import pg.table.csv.CsvData;

import java.util.List;
import java.util.UUID;

@NoArgsConstructor(staticName = "dummy")
@AllArgsConstructor
@Data
@Builder
public class CurriculumVitae implements CsvData {
    public static final String TABLE = "CV";
    public static final String COLUMNS = "cv_id,miasto,wojewodztwo,kod_pocztowy,kraj,ulica";
    private UUID id;
    private String city;
    private String voivodeship;
    private String postalCode;
    private String country;
    private String street;

    private List<Experience> experiences;
    private List<Education> educations;
    private List<Skill> skills;
    private List<Course> courses;

    @Override
    public String toString() {
        return "%s,%s,%s,%s,%s,%s".formatted(
                id,
                city,
                voivodeship,
                postalCode,
                country,
                street
        );
    }

    @Override
    public String getColumns() {
        return COLUMNS;
    }
}