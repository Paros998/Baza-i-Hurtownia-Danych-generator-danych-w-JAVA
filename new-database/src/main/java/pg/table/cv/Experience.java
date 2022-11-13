package pg.table.cv;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import pg.table.csv.CsvData;
import pg.utils.ListUtil;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@AllArgsConstructor
@NoArgsConstructor(staticName = "dummy")
@Data
@Builder
public class Experience implements CsvData {
    public static final String TABLE = "Doswiadczenie";
    public static final String COLUMNS = "doswiadczenie_id,cv_id,od,do,obowiazki,stanowisko,firma";
    private UUID id;
    private CurriculumVitae cv;
    private LocalDate since;
    private LocalDate to;
    private List<String> responsibilities;
    private String vacancy;
    private String companyName;

    @Override
    public String toString() {
        return "%s,%s,%s,%s,%s,%s,%s".formatted(
                id,
                cv.getId(),
                since.format(DateTimeFormatter.ISO_LOCAL_DATE),
                to.format(DateTimeFormatter.ISO_LOCAL_DATE),
                ListUtil.getCsvArray(responsibilities),
                vacancy,
                companyName
        );
    }

    @Override
    public String getColumns() {
        return COLUMNS;
    }
}