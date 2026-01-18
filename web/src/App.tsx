import { Router, Route } from "wouter";
import { ThemeProvider } from "@/contexts/ThemeContext";
import ErrorBoundary from "@/components/ErrorBoundary";
import Home from "@/pages/Home";
import NotFound from "@/pages/NotFound";

function App() {
  return (
    <ErrorBoundary>
      <ThemeProvider>
        <Router>
          <Route path="/" component={Home} />
          <Route component={NotFound} />
        </Router>
      </ThemeProvider>
    </ErrorBoundary>
  );
}

export default App;
