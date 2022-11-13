package pg;

import pg.generator.ProjectRecordsGenerator;
import pg.table.csv.CsvData;
import pg.utils.CsvWriter;

public class DataGenerator {

    public static void main(String[] args) {
        final Data data = new Data();

        CsvWriter.createFiles(CsvData.tables);

        final ProjectRecordsGenerator recordsGenerator = ProjectRecordsGenerator.of(data);

        String numberOfFactsProperty = System.getProperty("records");

        int numberOfFacts;
        try {
            numberOfFacts = Integer.parseInt(numberOfFactsProperty);
        } catch (NumberFormatException e) {
            numberOfFacts = 10000;
        }

        recordsGenerator.generateFacts(numberOfFacts);
    }
}