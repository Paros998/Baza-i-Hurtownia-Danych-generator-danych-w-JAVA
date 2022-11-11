package table.cv;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Data
@AllArgsConstructor
@Builder
public class Education {
    public static final String TABLE = "Wyksztalcenie";
    public static final String COLUMNS = "wyksztalcenie_id,cv_id,od,do,opis,nazwa";
    private UUID id;
    private UUID cvId;

    private LocalDate since;
    private LocalDate to;
    private String description;
    private String schoolName;

    @Override
    public String toString() {
        return "%s,%s,%s,%s,%s,%s".formatted(
                id,
                cvId,
                since.format(DateTimeFormatter.ISO_LOCAL_DATE),
                to.format(DateTimeFormatter.ISO_LOCAL_DATE),
                description,
                schoolName
        );
    }
}