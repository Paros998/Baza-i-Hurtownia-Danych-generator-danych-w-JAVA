package pg.utils;

import lombok.experimental.UtilityClass;

import pg.DataGenerator;
import pg.table.csv.CsvData;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Objects;

import static pg.utils.FileUtil.createFile;
import static pg.utils.FileUtil.loadFile;

@UtilityClass
public class CsvWriter {
    private final Path targetPath;
    private FileWriter writer;

    static {
        try {
            targetPath = Paths.get(Objects.requireNonNull(DataGenerator.class.getResource("/")).toURI()).getParent();
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

    public void createFiles(final List<CsvData> dataTypes) {
        dataTypes.forEach(csvData -> {
            File file = createFile(targetPath + csvData.getCsvFileName());
            try {
                writer = new FileWriter(file, StandardCharsets.UTF_8, true);
                writer.write(csvData.getColumns() + "\n");
                writer.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        });
    }

    public void writeRecordToFile(final CsvData csvData) {
        File recordFile = loadFile(targetPath + csvData.getCsvFileName());

        if (!recordFile.exists())
            throw new RuntimeException("Something went wrong with %s file creation".formatted(csvData.getCsvFileName()));

        try {
            writer = new FileWriter(recordFile, StandardCharsets.UTF_8, true);
            writer.write(csvData.getData() + "\n");
            writer.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
