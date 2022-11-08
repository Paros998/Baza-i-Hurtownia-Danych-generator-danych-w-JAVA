package table.cv;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@AllArgsConstructor
@Data
@Builder
public class Course {
    private UUID id;
    private UUID cvId;
    private LocalDate date;
    private LocalDate validTo;
    private String name;
    private String description;

    @Override
    public String toString() {
        return "%s,%s,%s,%s,%s,%s".formatted(
                id,
                cvId,
                date.format(DateTimeFormatter.ISO_LOCAL_DATE),
                validTo.format(DateTimeFormatter.ISO_LOCAL_DATE),
                name,
                description
        );
    }
}