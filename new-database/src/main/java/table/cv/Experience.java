package table.cv;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@AllArgsConstructor
@Data
@Builder
public class Experience {
    public static final String TABLE = "Doswiadczenie";
    public static final String COLUMNS = "doswiadczenie_id,cv_id,od,do,obowiazki,stanowisko,firma";
    private UUID id;
    private UUID cvId;
    private LocalDate since;
    private LocalDate to;
    // TODO fix all Lists toString
    private List<String> responsibilities;
    private String vacancy;
    private String companyName;

    @Override
    public String toString() {
        return "%s,%s,%s,%s,%s,%s,%s".formatted(
                id,
                cvId,
                since.format(DateTimeFormatter.ISO_LOCAL_DATE),
                to.format(DateTimeFormatter.ISO_LOCAL_DATE),
                responsibilities,
                vacancy,
                companyName
        );
    }
}