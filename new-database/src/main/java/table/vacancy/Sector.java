package table.vacancy;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@AllArgsConstructor
@Data
@Builder
public class Sector {
    private UUID id;
    private String name;
    private String description;
}