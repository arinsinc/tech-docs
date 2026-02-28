# Forms and Inputs in React

## Table of Contents
- [Introduction](#introduction)
- [Controlled Components](#controlled-components)
- [Uncontrolled Components](#uncontrolled-components)
- [Form Events](#form-events)
- [Input Types](#input-types)
- [Form Validation](#form-validation)
- [Form Submission](#form-submission)
- [Advanced Patterns](#advanced-patterns)
- [Form Libraries](#form-libraries)
- [Best Practices](#best-practices)
- [Common Patterns](#common-patterns)

## Introduction

Forms are essential for user interaction in web applications. React provides two main approaches to handle form inputs: controlled and uncontrolled components.

### Form Handling Approaches
- **Controlled Components**: React state controls the input value
- **Uncontrolled Components**: DOM manages the input value
- **Form Libraries**: Third-party libraries for complex forms

## Controlled Components

In controlled components, React state is the "single source of truth" for form data.

### Basic Text Input

```jsx
function NameForm() {
  const [name, setName] = useState('');

  const handleChange = (e) => {
    setName(e.target.value);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log('Submitted name:', name);
  };

  return (
    <form onSubmit={handleSubmit}>
      <label>
        Name:
        <input
          type="text"
          value={name}
          onChange={handleChange}
        />
      </label>
      <button type="submit">Submit</button>
    </form>
  );
}
```

### Multiple Inputs

```jsx
function RegistrationForm() {
  const [formData, setFormData] = useState({
    username: '',
    email: '',
    password: '',
    age: ''
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log('Form data:', formData);
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>
          Username:
          <input
            type="text"
            name="username"
            value={formData.username}
            onChange={handleChange}
          />
        </label>
      </div>

      <div>
        <label>
          Email:
          <input
            type="email"
            name="email"
            value={formData.email}
            onChange={handleChange}
          />
        </label>
      </div>

      <div>
        <label>
          Password:
          <input
            type="password"
            name="password"
            value={formData.password}
            onChange={handleChange}
          />
        </label>
      </div>

      <div>
        <label>
          Age:
          <input
            type="number"
            name="age"
            value={formData.age}
            onChange={handleChange}
          />
        </label>
      </div>

      <button type="submit">Register</button>
    </form>
  );
}
```

### Textarea

```jsx
function CommentForm() {
  const [comment, setComment] = useState('');

  return (
    <form>
      <label>
        Comment:
        <textarea
          value={comment}
          onChange={(e) => setComment(e.target.value)}
          rows={5}
          cols={40}
        />
      </label>
      <p>Character count: {comment.length}</p>
    </form>
  );
}
```

### Select Dropdown

```jsx
function CountrySelector() {
  const [country, setCountry] = useState('usa');

  return (
    <form>
      <label>
        Select Country:
        <select value={country} onChange={(e) => setCountry(e.target.value)}>
          <option value="usa">United States</option>
          <option value="canada">Canada</option>
          <option value="uk">United Kingdom</option>
          <option value="australia">Australia</option>
        </select>
      </label>
      <p>Selected: {country}</p>
    </form>
  );
}
```

### Checkboxes

```jsx
function PreferencesForm() {
  const [preferences, setPreferences] = useState({
    newsletter: false,
    notifications: false,
    updates: false
  });

  const handleCheckboxChange = (e) => {
    const { name, checked } = e.target;
    setPreferences(prev => ({
      ...prev,
      [name]: checked
    }));
  };

  return (
    <form>
      <label>
        <input
          type="checkbox"
          name="newsletter"
          checked={preferences.newsletter}
          onChange={handleCheckboxChange}
        />
        Subscribe to newsletter
      </label>

      <label>
        <input
          type="checkbox"
          name="notifications"
          checked={preferences.notifications}
          onChange={handleCheckboxChange}
        />
        Enable notifications
      </label>

      <label>
        <input
          type="checkbox"
          name="updates"
          checked={preferences.updates}
          onChange={handleCheckboxChange}
        />
        Receive product updates
      </label>
    </form>
  );
}
```

### Radio Buttons

```jsx
function SurveyForm() {
  const [rating, setRating] = useState('');

  return (
    <form>
      <fieldset>
        <legend>How satisfied are you?</legend>
        
        <label>
          <input
            type="radio"
            name="rating"
            value="very-satisfied"
            checked={rating === 'very-satisfied'}
            onChange={(e) => setRating(e.target.value)}
          />
          Very Satisfied
        </label>

        <label>
          <input
            type="radio"
            name="rating"
            value="satisfied"
            checked={rating === 'satisfied'}
            onChange={(e) => setRating(e.target.value)}
          />
          Satisfied
        </label>

        <label>
          <input
            type="radio"
            name="rating"
            value="neutral"
            checked={rating === 'neutral'}
            onChange={(e) => setRating(e.target.value)}
          />
          Neutral
        </label>

        <label>
          <input
            type="radio"
            name="rating"
            value="unsatisfied"
            checked={rating === 'unsatisfied'}
            onChange={(e) => setRating(e.target.value)}
          />
          Unsatisfied
        </label>
      </fieldset>
    </form>
  );
}
```

## Uncontrolled Components

Uncontrolled components use refs to access form values from the DOM.

### Basic Uncontrolled Input

```jsx
function UncontrolledForm() {
  const nameRef = useRef();

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log('Name:', nameRef.current.value);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input type="text" ref={nameRef} defaultValue="John" />
      <button type="submit">Submit</button>
    </form>
  );
}
```

### Multiple Refs

```jsx
function UncontrolledMultiForm() {
  const usernameRef = useRef();
  const emailRef = useRef();
  const passwordRef = useRef();

  const handleSubmit = (e) => {
    e.preventDefault();
    const formData = {
      username: usernameRef.current.value,
      email: emailRef.current.value,
      password: passwordRef.current.value
    };
    console.log('Form data:', formData);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input type="text" ref={usernameRef} placeholder="Username" />
      <input type="email" ref={emailRef} placeholder="Email" />
      <input type="password" ref={passwordRef} placeholder="Password" />
      <button type="submit">Submit</button>
    </form>
  );
}
```

### File Input (Always Uncontrolled)

```jsx
function FileUploadForm() {
  const fileInputRef = useRef();

  const handleSubmit = (e) => {
    e.preventDefault();
    const file = fileInputRef.current.files[0];
    if (file) {
      console.log('File name:', file.name);
      console.log('File size:', file.size);
      console.log('File type:', file.type);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input type="file" ref={fileInputRef} />
      <button type="submit">Upload</button>
    </form>
  );
}
```

## Form Events

### onChange Event

```jsx
function RealTimeValidation() {
  const [email, setEmail] = useState('');
  const [isValid, setIsValid] = useState(true);

  const handleChange = (e) => {
    const value = e.target.value;
    setEmail(value);
    setIsValid(value.includes('@'));
  };

  return (
    <div>
      <input
        type="email"
        value={email}
        onChange={handleChange}
        style={{ borderColor: isValid ? 'green' : 'red' }}
      />
      {!isValid && <span style={{ color: 'red' }}>Invalid email</span>}
    </div>
  );
}
```

### onBlur Event

```jsx
function BlurValidation() {
  const [username, setUsername] = useState('');
  const [touched, setTouched] = useState(false);
  const [error, setError] = useState('');

  const handleBlur = () => {
    setTouched(true);
    if (username.length < 3) {
      setError('Username must be at least 3 characters');
    } else {
      setError('');
    }
  };

  return (
    <div>
      <input
        type="text"
        value={username}
        onChange={(e) => setUsername(e.target.value)}
        onBlur={handleBlur}
      />
      {touched && error && <span style={{ color: 'red' }}>{error}</span>}
    </div>
  );
}
```

### onFocus Event

```jsx
function FocusHandler() {
  const [focused, setFocused] = useState(false);

  return (
    <div>
      <input
        type="text"
        onFocus={() => setFocused(true)}
        onBlur={() => setFocused(false)}
        placeholder="Click to focus"
      />
      {focused && <p>Input is focused</p>}
    </div>
  );
}
```

### onSubmit Event

```jsx
function FormSubmitHandler() {
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log('Form submitted');
    setSubmitted(true);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input type="text" name="username" />
      <button type="submit">Submit</button>
      {submitted && <p>Form submitted successfully!</p>}
    </form>
  );
}
```

## Input Types

### Text Inputs

```jsx
function TextInputs() {
  const [data, setData] = useState({
    text: '',
    email: '',
    password: '',
    tel: '',
    url: '',
    search: ''
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setData(prev => ({ ...prev, [name]: value }));
  };

  return (
    <form>
      <input type="text" name="text" value={data.text} onChange={handleChange} placeholder="Text" />
      <input type="email" name="email" value={data.email} onChange={handleChange} placeholder="Email" />
      <input type="password" name="password" value={data.password} onChange={handleChange} placeholder="Password" />
      <input type="tel" name="tel" value={data.tel} onChange={handleChange} placeholder="Phone" />
      <input type="url" name="url" value={data.url} onChange={handleChange} placeholder="URL" />
      <input type="search" name="search" value={data.search} onChange={handleChange} placeholder="Search" />
    </form>
  );
}
```

### Number and Range

```jsx
function NumericInputs() {
  const [number, setNumber] = useState(50);
  const [range, setRange] = useState(50);

  return (
    <form>
      <div>
        <label>
          Number (1-100):
          <input
            type="number"
            min="1"
            max="100"
            value={number}
            onChange={(e) => setNumber(e.target.value)}
          />
        </label>
      </div>

      <div>
        <label>
          Range: {range}
          <input
            type="range"
            min="0"
            max="100"
            value={range}
            onChange={(e) => setRange(e.target.value)}
          />
        </label>
      </div>
    </form>
  );
}
```

### Date and Time

```jsx
function DateTimeInputs() {
  const [date, setDate] = useState('');
  const [time, setTime] = useState('');
  const [datetime, setDatetime] = useState('');

  return (
    <form>
      <div>
        <label>
          Date:
          <input
            type="date"
            value={date}
            onChange={(e) => setDate(e.target.value)}
          />
        </label>
      </div>

      <div>
        <label>
          Time:
          <input
            type="time"
            value={time}
            onChange={(e) => setTime(e.target.value)}
          />
        </label>
      </div>

      <div>
        <label>
          DateTime:
          <input
            type="datetime-local"
            value={datetime}
            onChange={(e) => setDatetime(e.target.value)}
          />
        </label>
      </div>
    </form>
  );
}
```

### Color Picker

```jsx
function ColorPicker() {
  const [color, setColor] = useState('#ff0000');

  return (
    <div>
      <input
        type="color"
        value={color}
        onChange={(e) => setColor(e.target.value)}
      />
      <div style={{ 
        width: '100px', 
        height: '100px', 
        backgroundColor: color 
      }}>
        {color}
      </div>
    </div>
  );
}
```

## Form Validation

### Basic Validation

```jsx
function ValidatedForm() {
  const [formData, setFormData] = useState({
    username: '',
    email: '',
    password: ''
  });

  const [errors, setErrors] = useState({});

  const validate = () => {
    const newErrors = {};

    if (!formData.username) {
      newErrors.username = 'Username is required';
    } else if (formData.username.length < 3) {
      newErrors.username = 'Username must be at least 3 characters';
    }

    if (!formData.email) {
      newErrors.email = 'Email is required';
    } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      newErrors.email = 'Email is invalid';
    }

    if (!formData.password) {
      newErrors.password = 'Password is required';
    } else if (formData.password.length < 6) {
      newErrors.password = 'Password must be at least 6 characters';
    }

    return newErrors;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const validationErrors = validate();
    
    if (Object.keys(validationErrors).length === 0) {
      console.log('Form is valid:', formData);
      setErrors({});
    } else {
      setErrors(validationErrors);
    }
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <input
          type="text"
          name="username"
          value={formData.username}
          onChange={handleChange}
          placeholder="Username"
        />
        {errors.username && <span style={{ color: 'red' }}>{errors.username}</span>}
      </div>

      <div>
        <input
          type="email"
          name="email"
          value={formData.email}
          onChange={handleChange}
          placeholder="Email"
        />
        {errors.email && <span style={{ color: 'red' }}>{errors.email}</span>}
      </div>

      <div>
        <input
          type="password"
          name="password"
          value={formData.password}
          onChange={handleChange}
          placeholder="Password"
        />
        {errors.password && <span style={{ color: 'red' }}>{errors.password}</span>}
      </div>

      <button type="submit">Submit</button>
    </form>
  );
}
```

### Real-time Validation

```jsx
function RealTimeValidatedForm() {
  const [email, setEmail] = useState('');
  const [emailError, setEmailError] = useState('');
  const [touched, setTouched] = useState(false);

  const validateEmail = (value) => {
    if (!value) {
      return 'Email is required';
    }
    if (!/\S+@\S+\.\S+/.test(value)) {
      return 'Email is invalid';
    }
    return '';
  };

  const handleChange = (e) => {
    const value = e.target.value;
    setEmail(value);
    if (touched) {
      setEmailError(validateEmail(value));
    }
  };

  const handleBlur = () => {
    setTouched(true);
    setEmailError(validateEmail(email));
  };

  return (
    <div>
      <input
        type="email"
        value={email}
        onChange={handleChange}
        onBlur={handleBlur}
        style={{ borderColor: touched && emailError ? 'red' : 'gray' }}
      />
      {touched && emailError && <span style={{ color: 'red' }}>{emailError}</span>}
    </div>
  );
}
```

### Custom Validation Hook

```jsx
function useFormValidation(initialState, validate) {
  const [values, setValues] = useState(initialState);
  const [errors, setErrors] = useState({});
  const [touched, setTouched] = useState({});

  const handleChange = (e) => {
    const { name, value } = e.target;
    setValues(prev => ({ ...prev, [name]: value }));
  };

  const handleBlur = (e) => {
    const { name } = e.target;
    setTouched(prev => ({ ...prev, [name]: true }));
    const validationErrors = validate(values);
    setErrors(validationErrors);
  };

  const handleSubmit = (onSubmit) => (e) => {
    e.preventDefault();
    const validationErrors = validate(values);
    setErrors(validationErrors);

    if (Object.keys(validationErrors).length === 0) {
      onSubmit(values);
    }
  };

  return {
    values,
    errors,
    touched,
    handleChange,
    handleBlur,
    handleSubmit
  };
}

// Usage
function FormWithHook() {
  const validate = (values) => {
    const errors = {};
    if (!values.email) errors.email = 'Required';
    if (!values.password) errors.password = 'Required';
    return errors;
  };

  const { values, errors, touched, handleChange, handleBlur, handleSubmit } = 
    useFormValidation({ email: '', password: '' }, validate);

  const onSubmit = (data) => {
    console.log('Submitted:', data);
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input
        name="email"
        value={values.email}
        onChange={handleChange}
        onBlur={handleBlur}
      />
      {touched.email && errors.email && <span>{errors.email}</span>}

      <input
        name="password"
        type="password"
        value={values.password}
        onChange={handleChange}
        onBlur={handleBlur}
      />
      {touched.password && errors.password && <span>{errors.password}</span>}

      <button type="submit">Submit</button>
    </form>
  );
}
```

## Form Submission

### Basic Form Submission

```jsx
function BasicSubmit() {
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = (e) => {
    e.preventDefault();
    const formData = new FormData(e.target);
    const data = Object.fromEntries(formData);
    console.log('Form data:', data);
    setSubmitted(true);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input name="username" />
      <input name="email" type="email" />
      <button type="submit">Submit</button>
      {submitted && <p>Form submitted!</p>}
    </form>
  );
}
```

### Async Form Submission

```jsx
function AsyncSubmitForm() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    const formData = new FormData(e.target);
    const data = Object.fromEntries(formData);

    try {
      const response = await fetch('/api/submit', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      });

      if (!response.ok) throw new Error('Submission failed');

      setSuccess(true);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input name="username" required />
      <input name="email" type="email" required />
      
      <button type="submit" disabled={loading}>
        {loading ? 'Submitting...' : 'Submit'}
      </button>

      {error && <p style={{ color: 'red' }}>{error}</p>}
      {success && <p style={{ color: 'green' }}>Success!</p>}
    </form>
  );
}
```

### Multi-Step Form

```jsx
function MultiStepForm() {
  const [step, setStep] = useState(1);
  const [formData, setFormData] = useState({
    username: '',
    email: '',
    address: '',
    city: ''
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleNext = () => setStep(step + 1);
  const handlePrev = () => setStep(step - 1);

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log('Final data:', formData);
  };

  return (
    <form onSubmit={handleSubmit}>
      {step === 1 && (
        <div>
          <h2>Step 1: Personal Info</h2>
          <input
            name="username"
            value={formData.username}
            onChange={handleChange}
            placeholder="Username"
          />
          <input
            name="email"
            value={formData.email}
            onChange={handleChange}
            placeholder="Email"
          />
          <button type="button" onClick={handleNext}>Next</button>
        </div>
      )}

      {step === 2 && (
        <div>
          <h2>Step 2: Address</h2>
          <input
            name="address"
            value={formData.address}
            onChange={handleChange}
            placeholder="Address"
          />
          <input
            name="city"
            value={formData.city}
            onChange={handleChange}
            placeholder="City"
          />
          <button type="button" onClick={handlePrev}>Previous</button>
          <button type="submit">Submit</button>
        </div>
      )}
    </form>
  );
}
```

## Advanced Patterns

### Dynamic Form Fields

```jsx
function DynamicFieldsForm() {
  const [fields, setFields] = useState([{ id: 1, value: '' }]);

  const addField = () => {
    setFields([...fields, { id: Date.now(), value: '' }]);
  };

  const removeField = (id) => {
    setFields(fields.filter(field => field.id !== id));
  };

  const updateField = (id, value) => {
    setFields(fields.map(field =>
      field.id === id ? { ...field, value } : field
    ));
  };

  return (
    <form>
      {fields.map(field => (
        <div key={field.id}>
          <input
            value={field.value}
            onChange={(e) => updateField(field.id, e.target.value)}
          />
          <button type="button" onClick={() => removeField(field.id)}>
            Remove
          </button>
        </div>
      ))}
      <button type="button" onClick={addField}>Add Field</button>
    </form>
  );
}
```

### Autocomplete Input

```jsx
function AutocompleteInput() {
  const [value, setValue] = useState('');
  const [suggestions, setSuggestions] = useState([]);
  const [showSuggestions, setShowSuggestions] = useState(false);

  const allSuggestions = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'];

  const handleChange = (e) => {
    const input = e.target.value;
    setValue(input);

    if (input.length > 0) {
      const filtered = allSuggestions.filter(item =>
        item.toLowerCase().includes(input.toLowerCase())
      );
      setSuggestions(filtered);
      setShowSuggestions(true);
    } else {
      setShowSuggestions(false);
    }
  };

  const handleSelect = (suggestion) => {
    setValue(suggestion);
    setShowSuggestions(false);
  };

  return (
    <div>
      <input
        value={value}
        onChange={handleChange}
        onBlur={() => setTimeout(() => setShowSuggestions(false), 200)}
      />
      {showSuggestions && suggestions.length > 0 && (
        <ul>
          {suggestions.map((suggestion, index) => (
            <li key={index} onClick={() => handleSelect(suggestion)}>
              {suggestion}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
```

### Form with File Upload

```jsx
function FileUploadForm() {
  const [file, setFile] = useState(null);
  const [preview, setPreview] = useState(null);

  const handleFileChange = (e) => {
    const selectedFile = e.target.files[0];
    setFile(selectedFile);

    if (selectedFile && selectedFile.type.startsWith('image/')) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setPreview(reader.result);
      };
      reader.readAsDataURL(selectedFile);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!file) return;

    const formData = new FormData();
    formData.append('file', file);

    try {
      await fetch('/api/upload', {
        method: 'POST',
        body: formData
      });
      console.log('File uploaded');
    } catch (error) {
      console.error('Upload failed:', error);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input type="file" onChange={handleFileChange} accept="image/*" />
      {preview && <img src={preview} alt="Preview" style={{ maxWidth: '200px' }} />}
      <button type="submit" disabled={!file}>Upload</button>
    </form>
  );
}
```

## Form Libraries

### React Hook Form Example

```jsx
import { useForm } from 'react-hook-form';

function ReactHookFormExample() {
  const { register, handleSubmit, formState: { errors } } = useForm();

  const onSubmit = (data) => {
    console.log(data);
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input
        {...register('username', { 
          required: 'Username is required',
          minLength: { value: 3, message: 'Min length is 3' }
        })}
      />
      {errors.username && <span>{errors.username.message}</span>}

      <input
        {...register('email', {
          required: 'Email is required',
          pattern: {
            value: /\S+@\S+\.\S+/,
            message: 'Invalid email'
          }
        })}
      />
      {errors.email && <span>{errors.email.message}</span>}

      <button type="submit">Submit</button>
    </form>
  );
}
```

### Formik Example

```jsx
import { Formik, Form, Field, ErrorMessage } from 'formik';

function FormikExample() {
  const initialValues = { username: '', email: '' };

  const validate = (values) => {
    const errors = {};
    if (!values.username) errors.username = 'Required';
    if (!values.email) errors.email = 'Required';
    return errors;
  };

  const onSubmit = (values) => {
    console.log(values);
  };

  return (
    <Formik initialValues={initialValues} validate={validate} onSubmit={onSubmit}>
      <Form>
        <Field name="username" />
        <ErrorMessage name="username" component="span" />

        <Field name="email" type="email" />
        <ErrorMessage name="email" component="span" />

        <button type="submit">Submit</button>
      </Form>
    </Formik>
  );
}
```

## Best Practices

### 1. Use Controlled Components for Form State

```jsx
// ✅ Good - Controlled component
function ControlledForm() {
  const [email, setEmail] = useState('');
  
  return (
    <input
      type="email"
      value={email}
      onChange={(e) => setEmail(e.target.value)}
    />
  );
}
```

### 2. Validate on Blur, Not on Change

```jsx
// ✅ Good - Validate on blur to avoid annoying users
function FormWithBlurValidation() {
  const [email, setEmail] = useState('');
  const [error, setError] = useState('');

  const handleBlur = () => {
    if (!email.includes('@')) {
      setError('Invalid email');
    } else {
      setError('');
    }
  };

  return (
    <div>
      <input
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        onBlur={handleBlur}
      />
      {error && <span>{error}</span>}
    </div>
  );
}
```

### 3. Prevent Default Form Submission

```jsx
// ✅ Always prevent default
function Form() {
  const handleSubmit = (e) => {
    e.preventDefault(); // Prevents page reload
    // Handle submission
  };

  return <form onSubmit={handleSubmit}>...</form>;
}
```

### 4. Use Semantic HTML

```jsx
// ✅ Good - Semantic and accessible
function AccessibleForm() {
  return (
    <form>
      <label htmlFor="username">
        Username:
        <input id="username" type="text" />
      </label>
      
      <fieldset>
        <legend>Gender</legend>
        <label>
          <input type="radio" name="gender" value="male" />
          Male
        </label>
        <label>
          <input type="radio" name="gender" value="female" />
          Female
        </label>
      </fieldset>
      
      <button type="submit">Submit</button>
    </form>
  );
}
```

### 5. Disable Submit Button During Submission

```jsx
function FormWithLoadingState() {
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      await submitForm();
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input type="text" />
      <button type="submit" disabled={loading}>
        {loading ? 'Submitting...' : 'Submit'}
      </button>
    </form>
  );
}
```

## Common Patterns

### Search Form

```jsx
function SearchForm() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState([]);

  const handleSearch = async (e) => {
    e.preventDefault();
    const data = await fetch(`/api/search?q=${query}`).then(r => r.json());
    setResults(data);
  };

  return (
    <div>
      <form onSubmit={handleSearch}>
        <input
          type="search"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Search..."
        />
        <button type="submit">Search</button>
      </form>
      <ul>
        {results.map(result => (
          <li key={result.id}>{result.title}</li>
        ))}
      </ul>
    </div>
  );
}
```

### Login Form

```jsx
function LoginForm() {
  const [credentials, setCredentials] = useState({ email: '', password: '' });
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    try {
      const response = await fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(credentials)
      });

      if (!response.ok) throw new Error('Login failed');

      const data = await response.json();
      // Handle successful login
    } catch (err) {
      setError('Invalid credentials');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        value={credentials.email}
        onChange={(e) => setCredentials({ ...credentials, email: e.target.value })}
        placeholder="Email"
        required
      />
      <input
        type="password"
        value={credentials.password}
        onChange={(e) => setCredentials({ ...credentials, password: e.target.value })}
        placeholder="Password"
        required
      />
      {error && <p style={{ color: 'red' }}>{error}</p>}
      <button type="submit">Login</button>
    </form>
  );
}
```

## Summary

Forms are essential for user interaction in React applications:

**Key Concepts:**
- **Controlled Components**: React state manages input values
- **Uncontrolled Components**: DOM manages input values via refs
- **Form Validation**: Validate on blur for better UX
- **Form Submission**: Always prevent default behavior
- **Event Handling**: onChange, onBlur, onFocus, onSubmit

**Best Practices:**
- Use controlled components for most cases
- Validate on blur, not on every keystroke
- Provide clear error messages
- Disable submit button during async operations
- Use semantic HTML and proper labels
- Consider form libraries for complex forms

**Popular Form Libraries:**
- React Hook Form
- Formik
- Yup (for validation schemas)

Mastering forms in React enables you to create rich, interactive user experiences with proper validation and state management.

---

**Related Topics:**
- [Event Handling](05_EVENT_HANDLING.md)
- [State Management](03_STATE_MANAGEMENT.md)
- [Conditional Rendering](06_CONDITIONAL_RENDERING.md)
- [Custom Hooks](12_CUSTOM_HOOKS.md)
