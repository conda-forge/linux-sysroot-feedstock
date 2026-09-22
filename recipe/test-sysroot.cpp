#include <stdexcept>
#include <thread>
#include <vector>

int main() {
    std::vector<int> values;
    std::thread worker([&] { values.push_back(42); });
    worker.join();
    try {
        throw std::runtime_error("test exception unwinding");
    } catch (const std::runtime_error&) {
        return values.at(0) == 42 ? 0 : 1;
    }
    return 1;
}
