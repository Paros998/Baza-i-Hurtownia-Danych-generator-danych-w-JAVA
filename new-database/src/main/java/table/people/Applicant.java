package table.people;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Data
@AllArgsConstructor
@Builder
public class Applicant {
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
}