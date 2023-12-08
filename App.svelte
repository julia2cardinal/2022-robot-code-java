import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/")
public class ChartController {

    @GetMapping
    public String index(Model model) {
        // Simulating chart data
        Map<String, Object> state = new HashMap<>();
        state.put("chart1", new double[][]{{1, 2}, {2, 3}, {3, 4}});
        state.put("chart2", new double[][]{{1, 3}, {2, 4}, {3, 5}});
        model.addAttribute("state", state);

        return "index";
    }
}
