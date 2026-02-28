# Refs and DOM in React

## Table of Contents
- [Introduction](#introduction)
- [useRef Hook](#useref-hook)
- [Accessing DOM Elements](#accessing-dom-elements)
- [forwardRef](#forwardref)
- [useImperativeHandle](#useimperativehandle)
- [Callback Refs](#callback-refs)
- [Common Use Cases](#common-use-cases)
- [Refs vs State](#refs-vs-state)
- [Best Practices](#best-practices)
- [Common Patterns](#common-patterns)

## Introduction

Refs provide a way to access DOM nodes or React elements created in the render method. They allow you to interact with DOM elements directly and store mutable values that persist across renders without causing re-renders.

### What are Refs?

Refs are:
- Direct access to DOM elements
- Mutable values that persist across renders
- Don't cause re-renders when changed
- Useful for imperative operations

```jsx
function Component() {
  const ref = useRef(initialValue);
  // ref.current holds the mutable value
}
```

## useRef Hook

### Basic Usage

```jsx
function Counter() {
  const countRef = useRef(0);

  const increment = () => {
    countRef.current = countRef.current + 1;
    console.log('Count:', countRef.current); // Logs updated value
    // Component does NOT re-render
  };

  return (
    <div>
      <p>Count: {countRef.current}</p>
      <button onClick={increment}>Increment</button>
    </div>
  );
}
```

### Storing Previous Values

```jsx
function UsePrevious(value) {
  const ref = useRef();
  
  useEffect(() => {
    ref.current = value;
  }, [value]);
  
  return ref.current;
}

// Usage
function Counter() {
  const [count, setCount] = useState(0);
  const prevCount = UsePrevious(count);

  return (
    <div>
      <p>Current: {count}</p>
      <p>Previous: {prevCount}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}
```

### Storing Mutable Values

```jsx
function Timer() {
  const [seconds, setSeconds] = useState(0);
  const intervalRef = useRef();

  const start = () => {
    if (intervalRef.current) return;
    
    intervalRef.current = setInterval(() => {
      setSeconds(s => s + 1);
    }, 1000);
  };

  const stop = () => {
    clearInterval(intervalRef.current);
    intervalRef.current = null;
  };

  const reset = () => {
    stop();
    setSeconds(0);
  };

  useEffect(() => {
    return () => clearInterval(intervalRef.current);
  }, []);

  return (
    <div>
      <p>Time: {seconds}s</p>
      <button onClick={start}>Start</button>
      <button onClick={stop}>Stop</button>
      <button onClick={reset}>Reset</button>
    </div>
  );
}
```

### useRef vs useState

```jsx
function Comparison() {
  const [stateCount, setStateCount] = useState(0);
  const refCount = useRef(0);

  console.log('Component rendered');

  return (
    <div>
      <p>State Count: {stateCount}</p>
      <p>Ref Count: {refCount.current}</p>
      
      {/* Causes re-render */}
      <button onClick={() => setStateCount(stateCount + 1)}>
        Increment State
      </button>
      
      {/* Does NOT cause re-render */}
      <button onClick={() => {
        refCount.current++;
        console.log('Ref count:', refCount.current);
      }}>
        Increment Ref
      </button>
    </div>
  );
}
```

## Accessing DOM Elements

### Basic DOM Access

```jsx
function TextInputWithFocusButton() {
  const inputRef = useRef(null);

  const handleFocus = () => {
    inputRef.current.focus();
  };

  return (
    <div>
      <input ref={inputRef} type="text" />
      <button onClick={handleFocus}>Focus Input</button>
    </div>
  );
}
```

### Reading DOM Properties

```jsx
function MeasureElement() {
  const divRef = useRef(null);
  const [dimensions, setDimensions] = useState({ width: 0, height: 0 });

  const measure = () => {
    if (divRef.current) {
      setDimensions({
        width: divRef.current.offsetWidth,
        height: divRef.current.offsetHeight
      });
    }
  };

  return (
    <div>
      <div ref={divRef} style={{ width: '300px', height: '200px', background: 'lightblue' }}>
        Measure me
      </div>
      <button onClick={measure}>Measure</button>
      <p>Width: {dimensions.width}px, Height: {dimensions.height}px</p>
    </div>
  );
}
```

### Manipulating DOM

```jsx
function AnimatedBox() {
  const boxRef = useRef(null);

  const animate = () => {
    if (boxRef.current) {
      boxRef.current.style.transform = 'translateX(100px)';
      boxRef.current.style.transition = 'transform 0.3s';
    }
  };

  const reset = () => {
    if (boxRef.current) {
      boxRef.current.style.transform = 'translateX(0)';
    }
  };

  return (
    <div>
      <div
        ref={boxRef}
        style={{ width: '100px', height: '100px', background: 'blue' }}
      >
        Box
      </div>
      <button onClick={animate}>Animate</button>
      <button onClick={reset}>Reset</button>
    </div>
  );
}
```

### Multiple Refs

```jsx
function MultipleInputs() {
  const inputRefs = useRef([]);

  const focusInput = (index) => {
    inputRefs.current[index]?.focus();
  };

  return (
    <div>
      {[1, 2, 3, 4].map((num, index) => (
        <input
          key={num}
          ref={(el) => (inputRefs.current[index] = el)}
          placeholder={`Input ${num}`}
        />
      ))}
      <button onClick={() => focusInput(0)}>Focus First</button>
      <button onClick={() => focusInput(2)}>Focus Third</button>
    </div>
  );
}
```

## forwardRef

### Basic forwardRef

```jsx
const FancyInput = forwardRef((props, ref) => {
  return (
    <div className="fancy-input">
      <input ref={ref} {...props} />
    </div>
  );
});

// Usage
function App() {
  const inputRef = useRef();

  const handleFocus = () => {
    inputRef.current.focus();
  };

  return (
    <div>
      <FancyInput ref={inputRef} placeholder="Enter text" />
      <button onClick={handleFocus}>Focus</button>
    </div>
  );
}
```

### forwardRef with Additional Props

```jsx
const CustomButton = forwardRef(({ label, onClick, variant = 'primary' }, ref) => {
  return (
    <button
      ref={ref}
      onClick={onClick}
      className={`btn btn-${variant}`}
    >
      {label}
    </button>
  );
});

// Usage
function App() {
  const buttonRef = useRef();

  const handleClick = () => {
    buttonRef.current.focus();
    console.log('Button width:', buttonRef.current.offsetWidth);
  };

  return (
    <CustomButton
      ref={buttonRef}
      label="Click Me"
      onClick={handleClick}
      variant="secondary"
    />
  );
}
```

### Combining forwardRef with Internal Refs

```jsx
const VideoPlayer = forwardRef((props, ref) => {
  const internalRef = useRef();
  const videoRef = ref || internalRef;

  const play = () => videoRef.current?.play();
  const pause = () => videoRef.current?.pause();

  return (
    <div>
      <video ref={videoRef} {...props} />
      <button onClick={play}>Play</button>
      <button onClick={pause}>Pause</button>
    </div>
  );
});
```

## useImperativeHandle

### Basic useImperativeHandle

```jsx
const Input = forwardRef((props, ref) => {
  const inputRef = useRef();

  useImperativeHandle(ref, () => ({
    focus: () => {
      inputRef.current.focus();
    },
    clear: () => {
      inputRef.current.value = '';
    },
    getValue: () => {
      return inputRef.current.value;
    }
  }));

  return <input ref={inputRef} {...props} />;
});

// Usage
function App() {
  const inputRef = useRef();

  return (
    <div>
      <Input ref={inputRef} />
      <button onClick={() => inputRef.current.focus()}>Focus</button>
      <button onClick={() => inputRef.current.clear()}>Clear</button>
      <button onClick={() => alert(inputRef.current.getValue())}>
        Get Value
      </button>
    </div>
  );
}
```

### Custom Video Player with Controls

```jsx
const VideoPlayer = forwardRef(({ src }, ref) => {
  const videoRef = useRef();

  useImperativeHandle(ref, () => ({
    play: () => videoRef.current.play(),
    pause: () => videoRef.current.pause(),
    stop: () => {
      videoRef.current.pause();
      videoRef.current.currentTime = 0;
    },
    setVolume: (level) => {
      videoRef.current.volume = level;
    },
    getCurrentTime: () => videoRef.current.currentTime,
    getDuration: () => videoRef.current.duration
  }));

  return <video ref={videoRef} src={src} />;
});

// Usage
function App() {
  const playerRef = useRef();

  return (
    <div>
      <VideoPlayer ref={playerRef} src="video.mp4" />
      <button onClick={() => playerRef.current.play()}>Play</button>
      <button onClick={() => playerRef.current.pause()}>Pause</button>
      <button onClick={() => playerRef.current.stop()}>Stop</button>
      <button onClick={() => playerRef.current.setVolume(0.5)}>50% Volume</button>
    </div>
  );
}
```

### Form with Validation

```jsx
const FormField = forwardRef(({ label, ...props }, ref) => {
  const inputRef = useRef();
  const [error, setError] = useState('');

  useImperativeHandle(ref, () => ({
    validate: () => {
      const value = inputRef.current.value;
      if (!value) {
        setError('This field is required');
        return false;
      }
      setError('');
      return true;
    },
    getValue: () => inputRef.current.value,
    focus: () => inputRef.current.focus(),
    reset: () => {
      inputRef.current.value = '';
      setError('');
    }
  }));

  return (
    <div>
      <label>{label}</label>
      <input ref={inputRef} {...props} />
      {error && <span style={{ color: 'red' }}>{error}</span>}
    </div>
  );
});

// Usage
function Form() {
  const nameRef = useRef();
  const emailRef = useRef();

  const handleSubmit = (e) => {
    e.preventDefault();
    
    const nameValid = nameRef.current.validate();
    const emailValid = emailRef.current.validate();

    if (nameValid && emailValid) {
      console.log('Name:', nameRef.current.getValue());
      console.log('Email:', emailRef.current.getValue());
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <FormField ref={nameRef} label="Name" />
      <FormField ref={emailRef} label="Email" type="email" />
      <button type="submit">Submit</button>
    </form>
  );
}
```

## Callback Refs

### Basic Callback Ref

```jsx
function CallbackRefExample() {
  const [height, setHeight] = useState(0);

  const measureRef = (node) => {
    if (node !== null) {
      setHeight(node.getBoundingClientRect().height);
    }
  };

  return (
    <div>
      <div ref={measureRef} style={{ padding: '20px', background: 'lightblue' }}>
        <p>This content will be measured</p>
        <p>Its height is displayed below</p>
      </div>
      <p>Height: {height}px</p>
    </div>
  );
}
```

### Dynamic Callback Ref

```jsx
function DynamicList() {
  const [items, setItems] = useState(['Item 1', 'Item 2', 'Item 3']);
  const itemRefs = useRef({});

  const setRef = (id) => (node) => {
    if (node) {
      itemRefs.current[id] = node;
    } else {
      delete itemRefs.current[id];
    }
  };

  const scrollToItem = (id) => {
    itemRefs.current[id]?.scrollIntoView({ behavior: 'smooth' });
  };

  return (
    <div>
      {items.map((item, index) => (
        <div
          key={index}
          ref={setRef(index)}
          style={{ height: '100px', margin: '10px', background: 'lightgray' }}
        >
          {item}
        </div>
      ))}
      <button onClick={() => scrollToItem(2)}>Scroll to Item 3</button>
    </div>
  );
}
```

### Observing DOM Changes

```jsx
function ObserverExample() {
  const [isVisible, setIsVisible] = useState(false);

  const observerRef = useCallback((node) => {
    if (node) {
      const observer = new IntersectionObserver(
        ([entry]) => setIsVisible(entry.isIntersecting),
        { threshold: 0.5 }
      );
      observer.observe(node);
      
      return () => observer.disconnect();
    }
  }, []);

  return (
    <div>
      <div style={{ height: '150vh' }}>Scroll down</div>
      <div ref={observerRef} style={{ padding: '50px', background: 'lightblue' }}>
        {isVisible ? 'I am visible! 👀' : 'I am not visible'}
      </div>
    </div>
  );
}
```

## Common Use Cases

### Auto-Focus on Mount

```jsx
function AutoFocusInput() {
  const inputRef = useRef();

  useEffect(() => {
    inputRef.current.focus();
  }, []);

  return <input ref={inputRef} placeholder="Auto-focused input" />;
}
```

### Scroll to Element

```jsx
function ScrollToSection() {
  const sectionRef = useRef();

  const scrollToSection = () => {
    sectionRef.current.scrollIntoView({ behavior: 'smooth' });
  };

  return (
    <div>
      <button onClick={scrollToSection}>Scroll to Section</button>
      <div style={{ height: '100vh' }}>Scroll down...</div>
      <div ref={sectionRef} style={{ padding: '50px', background: 'lightblue' }}>
        Target Section
      </div>
    </div>
  );
}
```

### Canvas Drawing

```jsx
function CanvasDrawing() {
  const canvasRef = useRef();

  useEffect(() => {
    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');
    
    // Draw
    ctx.fillStyle = 'blue';
    ctx.fillRect(10, 10, 100, 100);
    ctx.fillStyle = 'red';
    ctx.fillRect(50, 50, 100, 100);
  }, []);

  return <canvas ref={canvasRef} width={400} height={400} />;
}
```

### Click Outside Detection

```jsx
function ClickOutsideDetector() {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef();

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  return (
    <div>
      <button onClick={() => setIsOpen(!isOpen)}>Toggle Dropdown</button>
      {isOpen && (
        <div ref={dropdownRef} style={{ border: '1px solid black', padding: '20px' }}>
          Dropdown content
          <p>Click outside to close</p>
        </div>
      )}
    </div>
  );
}
```

### Managing Focus Trap

```jsx
function Modal({ isOpen, onClose, children }) {
  const modalRef = useRef();
  const firstFocusableRef = useRef();
  const lastFocusableRef = useRef();

  useEffect(() => {
    if (!isOpen) return;

    firstFocusableRef.current?.focus();

    const handleTabKey = (e) => {
      if (e.key !== 'Tab') return;

      if (e.shiftKey) {
        if (document.activeElement === firstFocusableRef.current) {
          e.preventDefault();
          lastFocusableRef.current?.focus();
        }
      } else {
        if (document.activeElement === lastFocusableRef.current) {
          e.preventDefault();
          firstFocusableRef.current?.focus();
        }
      }
    };

    const handleEscKey = (e) => {
      if (e.key === 'Escape') onClose();
    };

    document.addEventListener('keydown', handleTabKey);
    document.addEventListener('keydown', handleEscKey);

    return () => {
      document.removeEventListener('keydown', handleTabKey);
      document.removeEventListener('keydown', handleEscKey);
    };
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  return (
    <div className="modal-overlay">
      <div ref={modalRef} className="modal">
        <button ref={firstFocusableRef} onClick={onClose}>Close</button>
        {children}
        <button ref={lastFocusableRef}>OK</button>
      </div>
    </div>
  );
}
```

### Media Query Detection

```jsx
function useMediaQuery(query) {
  const mediaQueryRef = useRef();
  const [matches, setMatches] = useState(false);

  useEffect(() => {
    mediaQueryRef.current = window.matchMedia(query);
    setMatches(mediaQueryRef.current.matches);

    const handler = (e) => setMatches(e.matches);
    mediaQueryRef.current.addEventListener('change', handler);

    return () => mediaQueryRef.current.removeEventListener('change', handler);
  }, [query]);

  return matches;
}

// Usage
function ResponsiveComponent() {
  const isMobile = useMediaQuery('(max-width: 768px)');

  return (
    <div>
      {isMobile ? <MobileView /> : <DesktopView />}
    </div>
  );
}
```

## Refs vs State

### When to Use Refs

```jsx
// ✅ Use refs for:
function GoodRefUsage() {
  // 1. DOM manipulation
  const inputRef = useRef();
  const focus = () => inputRef.current.focus();

  // 2. Storing mutable values that don't affect rendering
  const countRef = useRef(0);
  const increment = () => countRef.current++;

  // 3. Storing timer IDs
  const timerRef = useRef();
  const startTimer = () => {
    timerRef.current = setInterval(() => console.log('tick'), 1000);
  };

  // 4. Storing previous values
  const prevValueRef = useRef();
  useEffect(() => {
    prevValueRef.current = someValue;
  });

  return <div>...</div>;
}
```

### When to Use State

```jsx
// ✅ Use state for:
function GoodStateUsage() {
  // 1. Values that affect rendering
  const [count, setCount] = useState(0);

  // 2. User input
  const [text, setText] = useState('');

  // 3. UI state
  const [isOpen, setIsOpen] = useState(false);

  // 4. Data from APIs
  const [data, setData] = useState(null);

  return <div>Count: {count}</div>;
}
```

## Best Practices

### 1. Don't Overuse Refs

```jsx
// ❌ Bad - Using ref when state is better
function BadExample() {
  const countRef = useRef(0);
  
  return (
    <div>
      <p>Count: {countRef.current}</p>
      <button onClick={() => countRef.current++}>Increment</button>
    </div>
  );
}

// ✅ Good - Use state for rendered values
function GoodExample() {
  const [count, setCount] = useState(0);
  
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}
```

### 2. Check Ref Current Before Using

```jsx
// ✅ Good - Always check if ref.current exists
function SafeRefUsage() {
  const elementRef = useRef();

  const doSomething = () => {
    if (elementRef.current) {
      elementRef.current.focus();
    }
  };

  return <input ref={elementRef} />;
}
```

### 3. Don't Read/Write Refs During Render

```jsx
// ❌ Bad - Reading ref during render
function BadRender() {
  const ref = useRef(0);
  ref.current++; // Side effect during render!
  return <div>{ref.current}</div>;
}

// ✅ Good - Use effects or event handlers
function GoodRender() {
  const ref = useRef(0);
  
  useEffect(() => {
    ref.current++;
  });

  return <div>...</div>;
}
```

### 4. Use forwardRef for Reusable Components

```jsx
// ✅ Good - Allow parent to access DOM
const CustomInput = forwardRef((props, ref) => {
  return <input ref={ref} {...props} />;
});
```

### 5. Clean Up Side Effects

```jsx
// ✅ Good - Clean up timers and listeners
function TimerComponent() {
  const timerRef = useRef();

  useEffect(() => {
    timerRef.current = setInterval(() => {
      console.log('tick');
    }, 1000);

    return () => {
      if (timerRef.current) {
        clearInterval(timerRef.current);
      }
    };
  }, []);

  return <div>Timer running</div>;
}
```

## Common Patterns

### Previous Value Hook

```jsx
function usePrevious(value) {
  const ref = useRef();
  
  useEffect(() => {
    ref.current = value;
  }, [value]);
  
  return ref.current;
}

// Usage
function Counter() {
  const [count, setCount] = useState(0);
  const prevCount = usePrevious(count);

  return (
    <div>
      <p>Now: {count}, Before: {prevCount}</p>
      <button onClick={() => setCount(count + 1)}>+</button>
    </div>
  );
}
```

### Debounced Value with Ref

```jsx
function useDebouncedCallback(callback, delay) {
  const timeoutRef = useRef();
  const callbackRef = useRef(callback);

  useEffect(() => {
    callbackRef.current = callback;
  }, [callback]);

  return useCallback((...args) => {
    clearTimeout(timeoutRef.current);
    timeoutRef.current = setTimeout(() => {
      callbackRef.current(...args);
    }, delay);
  }, [delay]);
}
```

### Lazy Initialization

```jsx
function ExpensiveComponent() {
  const expensiveValue = useRef(null);

  if (expensiveValue.current === null) {
    expensiveValue.current = computeExpensiveValue();
  }

  return <div>{expensiveValue.current}</div>;
}
```

## Summary

Refs are a powerful tool for interacting with the DOM and storing mutable values:

**Key Concepts:**
- `useRef` creates a mutable ref object
- `ref.current` holds the mutable value
- Refs don't cause re-renders when changed
- `forwardRef` passes refs to child components
- `useImperativeHandle` customizes exposed ref values
- Callback refs provide more control over ref lifecycle

**Common Uses:**
- Accessing DOM elements directly
- Storing mutable values (timers, intervals)
- Keeping track of previous values
- Managing focus
- Triggering animations
- Integrating with third-party DOM libraries

**Best Practices:**
- Use state for values that affect rendering
- Use refs for values that don't affect rendering
- Always check if `ref.current` exists
- Clean up side effects in useEffect
- Don't read/write refs during render
- Use `forwardRef` for reusable components

**Remember:**
- Refs provide an escape hatch to work with DOM
- Prefer declarative React patterns when possible
- Use refs sparingly and intentionally
- Document why refs are necessary in complex cases

Understanding refs enables you to bridge the gap between React's declarative nature and imperative DOM operations when necessary.

---

**Related Topics:**
- [Effects and Lifecycle](04_EFFECTS_LIFECYCLE.md)
- [Advanced Hooks](11_ADVANCED_HOOKS.md)
- [Custom Hooks](12_CUSTOM_HOOKS.md)
- [Performance Optimization](14_PERFORMANCE.md)
